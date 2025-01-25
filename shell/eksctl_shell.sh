#!/bin/bash
# command ./eksctl_shell.sh
# eksctl yaml execution
# eksctl yaml 파일 실행 스크립트

source ~/.bash_profile
# Load environment variables from bash_profile
# bash_profile에서 환경 변수를 로드

cat << EOF > ~/environment/myeks/eksworkshop.yaml
# Start writing the EKS configuration YAML file
# EKS 클러스터 구성 YAML 파일 생성 시작

---
apiVersion: eksctl.io/v1alpha5
# Specify the API version of eksctl
# eksctl API 버전 지정
kind: ClusterConfig
# Specify the kind of configuration (ClusterConfig)
# 구성 종류를 클러스터 설정으로 지정
metadata:
  name: ${EKSCLUSTER_NAME}
  # Set the cluster name from the environment variable
  # 환경 변수에서 클러스터 이름 설정
  region: ${AWS_REGION}
  # Set the AWS region from the environment variable
  # 환경 변수에서 AWS 리전을 설정
  version: "${EKS_VERSION}"  
  # Set the EKS version from the environment variable
  # 환경 변수에서 EKS 버전을 설정
vpc: 
  id: ${VPC_ID}
  # Use the VPC ID from the environment variable
  # 환경 변수에서 VPC ID를 사용
  subnets:
    public:
      PublicSubnet01:
        az: ${AWS_REGION}a
        id: ${PublicSubnet01}
        # Define public subnet 01 with its AZ and ID
        # 가용 영역과 ID로 퍼블릭 서브넷 01 정의
      PublicSubnet02:
        az: ${AWS_REGION}b
        id: ${PublicSubnet02}
        # Define public subnet 02 with its AZ and ID
        # 가용 영역과 ID로 퍼블릭 서브넷 02 정의
      PublicSubnet03:
        az: ${AWS_REGION}c
        id: ${PublicSubnet03}
        # Define public subnet 03 with its AZ and ID
        # 가용 영역과 ID로 퍼블릭 서브넷 03 정의
    private:
      PrivateSubnet01:
        az: ${AWS_REGION}a
        id: ${PrivateSubnet01}
        # Define private subnet 01 with its AZ and ID
        # 가용 영역과 ID로 프라이빗 서브넷 01 정의
      PrivateSubnet02:
        az: ${AWS_REGION}b
        id: ${PrivateSubnet02}
        # Define private subnet 02 with its AZ and ID
        # 가용 영역과 ID로 프라이빗 서브넷 02 정의
      PrivateSubnet03:
        az: ${AWS_REGION}c
        id: ${PrivateSubnet03}
        # Define private subnet 03 with its AZ and ID
        # 가용 영역과 ID로 프라이빗 서브넷 03 정의
secretsEncryption:
  keyARN: ${MASTER_ARN}
  # Set encryption key ARN for secrets
  # 비밀값 암호화를 위한 키 ARN 설정

nodeGroups:
  - name: ng-public-01
    # Define a self-managed public node group
    # 셀프 관리 퍼블릭 노드 그룹 정의
    instanceType: ${INSTANCE_TYPE}
    # Instance type for the node group
    # 노드 그룹의 인스턴스 유형
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
      # List the subnets for the node group
      # 노드 그룹에 사용할 서브넷 목록
    desiredCapacity: 3
    # Desired number of nodes in the group
    # 노드 그룹의 원하는 노드 수
    minSize: 3
    maxSize: 6
    # Minimum and maximum node count
    # 최소 및 최대 노드 수
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    # Node volume configuration
    # 노드 볼륨 설정
    amiFamily: AmazonLinux2
    # Use Amazon Linux 2 AMI
    # Amazon Linux 2 AMI 사용
    labels:
      nodegroup-type: "${PUBLIC_SELFMGMD_NODE}"
      # Label for node group
      # 노드 그룹 레이블
    iam:
      attachPolicyARNs:
      # IAM policies for the node group
      # 노드 그룹을 위한 IAM 정책
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true
        # Add-on policies for additional features
        # 추가 기능을 위한 정책 추가

  - name: ng-private-01
    # Define a self-managed private node group
    # 셀프 관리 프라이빗 노드 그룹 정의
    privateNetworking: true
    # Enable private networking for the node group
    # 노드 그룹에 프라이빗 네트워킹 활성화

managedNodeGroups:
  - name: managed-ng-public-01
    # Define a managed public node group
    # 관리형 퍼블릭 노드 그룹 정의
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
    # Same configurations as self-managed node group
    # 셀프 관리 노드 그룹과 동일한 설정

  - name: managed-ng-private-01
    # Define a managed private node group
    # 관리형 프라이빗 노드 그룹 정의
    privateNetworking: true
    # Enable private networking for the node group
    # 노드 그룹에 프라이빗 네트워킹 활성화

cloudWatch:
    clusterLogging:
        enableTypes: ["api", "audit", "authenticator", "controllerManager", "scheduler"]
        # Enable CloudWatch logging for specified components
        # 지정된 구성 요소에 대해 CloudWatch 로깅 활성화

iam:
  withOIDC: true
  # Enable IAM OIDC provider for the cluster
  # 클러스터에 IAM OIDC 프로바이더 활성화

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
    # Enable add-ons for network, storage, and DNS
    # 네트워크, 스토리지, DNS를 위한 추가 기능 활성화
EOF
