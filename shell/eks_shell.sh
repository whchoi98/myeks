#!/bin/bash
# eks_shell.sh: EKS 환경 변수 설정 스크립트
# EKS 버전은 사용자로부터 입력받고, 관련 변수는 .bash_profile에 저장

set -e

cd ~/environment || exit 1

echo "🧭 [1/4] VPC/Subnet 정보 추출 중..."

# Subnet과 VPC 이름 정의
export VPC_NAME="eksworkshop"
declare -A SUBNET_NAMES=(
  [PublicSubnet01]="eksworkshop-PublicSubnet01"
  [PublicSubnet02]="eksworkshop-PublicSubnet02"
  [PublicSubnet03]="eksworkshop-PublicSubnet03"
  [PrivateSubnet01]="eksworkshop-PrivateSubnet01"
  [PrivateSubnet02]="eksworkshop-PrivateSubnet02"
  [PrivateSubnet03]="eksworkshop-PrivateSubnet03"
)

# VPC ID 조회
export VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" | jq -r '.Vpcs[0].VpcId')

# Subnet ID 조회
for key in "${!SUBNET_NAMES[@]}"; do
  export "$key"=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAMES[$key]}" | jq -r '.Subnets[0].SubnetId')
done

# 중복 방지 후 환경 변수 저장
append_to_bash_profile() {
  VAR=$1
  VALUE=$2
  grep -q "export $VAR=" ~/.bash_profile || echo "export $VAR=$VALUE" >> ~/.bash_profile
}

append_to_bash_profile "VPC_ID" "$VPC_ID"
for key in "${!SUBNET_NAMES[@]}"; do
  append_to_bash_profile "$key" "${!key}"
done

echo "✅ VPC 및 Subnet ID 환경변수 저장 완료"

# 사용자로부터 EKS 버전 입력
echo "🧭 [2/4] EKS 버전 입력 받는 중..."
read -rp "Enter the EKS version (default: 1.31): " USER_EKS_VERSION
EKS_VERSION="${USER_EKS_VERSION:-1.31}"
echo "🛠️ 선택된 EKS 버전: ${EKS_VERSION}"

# EKS 관련 변수 정의
export EKSCLUSTER_NAME="eksworkshop"
export INSTANCE_TYPE="m6i.xlarge"
export PUBLIC_SELFMGMD_NODE="frontend-workloads"
export PRIVATE_SELFMGMD_NODE="backend-workloads"
export PUBLIC_MGMD_NODE="managed-frontend-workloads"
export PRIVATE_MGMD_NODE="managed-backend-workloads"

append_to_bash_profile "EKSCLUSTER_NAME" "$EKSCLUSTER_NAME"
append_to_bash_profile "EKS_VERSION" "$EKS_VERSION"
append_to_bash_profile "INSTANCE_TYPE" "$INSTANCE_TYPE"
append_to_bash_profile "PUBLIC_SELFMGMD_NODE" "$PUBLIC_SELFMGMD_NODE"
append_to_bash_profile "PRIVATE_SELFMGMD_NODE" "$PRIVATE_SELFMGMD_NODE"
append_to_bash_profile "PUBLIC_MGMD_NODE" "$PUBLIC_MGMD_NODE"
append_to_bash_profile "PRIVATE_MGMD_NODE" "$PRIVATE_MGMD_NODE"

echo "✅ EKS 관련 환경변수 저장 완료"

echo "🧭 [3/4] .bash_profile 적용 중..."
source ~/.bash_profile

echo "🎉 [4/4] 완료: 모든 환경변수가 설정되었습니다!"
