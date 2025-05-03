#!/bin/bash
# eksctl_shell.sh - eksctl 기반 EKS 클러스터 YAML 생성 스크립트

set -eo pipefail

echo "🔧 [1/3] eksctl YAML 파일 생성 시작..."

# 작업 디렉토리 설정
WORKDIR=~/environment/myeks
mkdir -p "$WORKDIR"
YAML_FILE="${WORKDIR}/eksworkshop.yaml"

# 환경 변수 로드
source ~/.bash_profile

# 필수 환경 변수 검증
REQUIRED_VARS=(
  EKSCLUSTER_NAME AWS_REGION EKS_VERSION VPC_ID
  PublicSubnet01 PublicSubnet02 PublicSubnet03
  PrivateSubnet01 PrivateSubnet02 PrivateSubnet03
  MASTER_ARN INSTANCE_TYPE
  PUBLIC_SELFMGMD_NODE PRIVATE_SELFMGMD_NODE
  PUBLIC_MGMD_NODE PRIVATE_MGMD_NODE
)

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "❌ 환경 변수 $var 가 정의되어 있지 않습니다. 먼저 eks_shell.sh 를 실행하세요."
    exit 1
  fi
done

# YAML 파일 생성
cat <<EOF > "$YAML_FILE"
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: ${EKSCLUSTER_NAME}
  region: ${AWS_REGION}
  version: "${EKS_VERSION}"

vpc: 
  id: ${VPC_ID}
  subnets:
    public:
      PublicSubnet01:
        az: ${AWS_REGION}a
        id: ${PublicSubnet01}
      PublicSubnet02:
        az: ${AWS_REGION}b
        id: ${PublicSubnet02}
      PublicSubnet03:
        az: ${AWS_REGION}c
        id: ${PublicSubnet03}
    private:
      PrivateSubnet01:
        az: ${AWS_REGION}a
        id: ${PrivateSubnet01}
      PrivateSubnet02:
        az: ${AWS_REGION}b
        id: ${PrivateSubnet02}
      PrivateSubnet03:
        az: ${AWS_REGION}c
        id: ${PrivateSubnet03}

secretsEncryption:
  keyARN: ${MASTER_ARN}

nodeGroups:
  - name: ng-public-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PUBLIC_SELFMGMD_NODE}"
    iam:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true

  - name: ng-private-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PrivateSubnet01}
      - ${PrivateSubnet02}
      - ${PrivateSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PRIVATE_SELFMGMD_NODE}"
    privateNetworking: true

managedNodeGroups:
  - name: managed-ng-public-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PUBLIC_MGMD_NODE}"
    iam:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true

  - name: managed-ng-private-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PrivateSubnet01}
      - ${PrivateSubnet02}
      - ${PrivateSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PRIVATE_MGMD_NODE}"
    privateNetworking: true
    iam:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true

cloudWatch:
  clusterLogging:
    enableTypes: ["api", "audit", "authenticator", "controllerManager", "scheduler"]

iam:
  withOIDC: true

addons:
  - name: vpc-cni
    attachPolicyARNs:
      - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
  - name: coredns
    version: latest
  - name: kube-proxy
    version: latest
  - name: aws-ebs-csi-driver
    wellKnownPolicies:
      ebsCSIController: true
EOF

echo "✅ [2/3] YAML 파일이 성공적으로 생성되었습니다: $YAML_FILE"

# 출력 여부 확인
read -p "📄 YAML 내용을 확인하시겠습니까? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "------------------------------"
  cat "$YAML_FILE"
  echo "------------------------------"
fi

echo "🚀 [3/3] 클러스터 생성을 원하시면 아래 명령어를 실행하세요:"
echo "eksctl create cluster -f $YAML_FILE"