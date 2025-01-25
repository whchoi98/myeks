#!/bin/bash

# 사용자 입력 받기 / Get user input
read -p "Enter the VPC Name (VPC 이름 입력): " VPC_NAME
read -p "Enter the Security Group Name (Security Group 이름 입력): " SG_NAME

# 기본 설정 / Default settings
DESCRIPTION="Security Group created via script" # 보안 그룹 설명
PORT_RANGE_START=30080  # 시작 포트 / Starting port
PORT_RANGE_END=30090    # 종료 포트 / Ending port
CIDR="0.0.0.0/0"        # 허용되는 IP 범위 / Allowed IP range

echo "Fetching VPC ID for VPC name: $VPC_NAME..."
# VPC 이름으로 VPC ID를 검색 / Get VPC ID based on the provided VPC name

# VPC ID 가져오기 / Get VPC ID
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text)

if [ "$VPC_ID" == "None" ]; then
  echo "Error: VPC with name '${VPC_NAME}' not found."
  echo "오류: '${VPC_NAME}' 이름의 VPC를 찾을 수 없습니다."
  exit 1
fi

echo "VPC ID found: $VPC_ID"
# VPC ID 확인 / Confirm VPC ID

# Security Group 생성 / Create Security Group
echo "Creating Security Group: $SG_NAME in VPC: $VPC_ID..."
SG_ID=$(aws ec2 create-security-group \
  --group-name "$SG_NAME" \
  --description "$DESCRIPTION" \
  --vpc-id "$VPC_ID" \
  --query "GroupId" --output text)

if [ -z "$SG_ID" ]; then
  echo "Error: Failed to create Security Group."
  echo "오류: Security Group 생성 실패."
  exit 1
fi

echo "Security Group created with ID: $SG_ID"
# Security Group ID 확인 / Confirm Security Group ID

# 인바운드 규칙 추가 / Add inbound rules
echo "Adding inbound rule to allow TCP $PORT_RANGE_START-$PORT_RANGE_END from $CIDR..."
aws ec2 authorize-security-group-ingress \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port "$PORT_RANGE_START"-"$PORT_RANGE_END" \
  --cidr "$CIDR"

if [ $? -eq 0 ]; then
  echo "Inbound rule added successfully."
  echo "인바운드 규칙 추가 완료."
else
  echo "Error: Failed to add inbound rule."
  echo "오류: 인바운드 규칙 추가 실패."
  exit 1
fi

# 태그 추가 / Add tags
echo "Adding tag: Name=$SG_NAME to Security Group..."
aws ec2 create-tags \
  --resources "$SG_ID" \
  --tags Key=Name,Value="$SG_NAME"

if [ $? -eq 0 ]; then
  echo "Tag added successfully."
  echo "태그 추가 완료."
else
  echo "Error: Failed to add tag."
  echo "오류: 태그 추가 실패."
  exit 1
fi

echo "Security Group $SG_NAME created successfully with ID: $SG_ID"
echo "Security Group 생성 성공: $SG_NAME, ID: $SG_ID"