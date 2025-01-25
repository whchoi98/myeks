#!/bin/bash

# 사용자 입력 받기 / Get user input
read -p "Enter the Node Name (노드 이름 입력): " NODE_NAME
read -p "Enter the Security Group Name (Security Group 이름 입력): " SG_NAME

echo "Fetching Security Group ID for Security Group Name: $SG_NAME..."
# Security Group ID 가져오기 / Get Security Group ID
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME}" --query "SecurityGroups[0].GroupId" --output text)

if [ "$SG_ID" == "None" ]; then
  echo "Error: Security Group with name '${SG_NAME}' not found."
  echo "오류: '${SG_NAME}' 이름의 Security Group을 찾을 수 없습니다."
  exit 1
fi

echo "Security Group ID found: $SG_ID"
# Security Group ID 확인 / Confirm Security Group ID

echo "Fetching Instance IDs for Node Name: $NODE_NAME..."
# EC2 태그로 주어진 노드 이름에 해당하는 모든 EC2 인스턴스 검색 / Get all Instance IDs with the given Node Name tag
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${NODE_NAME}" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "Error: No instances found for node name '${NODE_NAME}'."
  echo "오류: 노드 이름 '${NODE_NAME}'에 해당하는 인스턴스를 찾을 수 없습니다."
  exit 1
fi

echo "Found Instance IDs: $INSTANCE_IDS"
# 인스턴스 ID 목록 확인 / Confirm list of Instance IDs

# 모든 인스턴스에 대해 반복 / Iterate over all instances
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "Processing Instance ID: $INSTANCE_ID..."

  # 네트워크 인터페이스 ID 가져오기 / Get Network Interface ID
  NETWORK_INTERFACE_ID=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId" \
    --output text)

  if [ "$NETWORK_INTERFACE_ID" == "None" ]; then
    echo "Error: Network Interface for instance '${INSTANCE_ID}' not found."
    echo "오류: 인스턴스 '${INSTANCE_ID}'에 대한 네트워크 인터페이스를 찾을 수 없습니다."
    continue
  fi

  echo "Network Interface ID found: $NETWORK_INTERFACE_ID"
  # 네트워크 인터페이스 ID 확인 / Confirm Network Interface ID

  # 기존 Security Group ID 가져오기 / Get current Security Groups
  CURRENT_SG_IDS=$(aws ec2 describe-network-interfaces \
    --network-interface-ids "$NETWORK_INTERFACE_ID" \
    --query "NetworkInterfaces[0].Groups[*].GroupId" \
    --output text)

  echo "Current Security Groups for Instance $INSTANCE_ID: $CURRENT_SG_IDS"

  # Security Group 추가 / Add Security Group
  echo "Adding Security Group $SG_NAME ($SG_ID) to Network Interface $NETWORK_INTERFACE_ID..."
  aws ec2 modify-network-interface-attribute \
    --network-interface-id "$NETWORK_INTERFACE_ID" \
    --groups $CURRENT_SG_IDS $SG_ID

  if [ $? -eq 0 ]; then
    echo "Security Group $SG_NAME added successfully to instance $INSTANCE_ID."
    echo "보안 그룹 $SG_NAME이 인스턴스 $INSTANCE_ID에 성공적으로 추가되었습니다."
  else
    echo "Error: Failed to add Security Group to instance $INSTANCE_ID."
    echo "오류: 인스턴스 $INSTANCE_ID에 보안 그룹 추가 실패."
  fi
done

echo "Script execution completed."
echo "스크립트 실행이 완료되었습니다."