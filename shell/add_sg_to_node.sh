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

echo "Fetching Instance ID for Node Name: $NODE_NAME..."
# 노드 이름으로 인스턴스 ID 검색 / Get Instance ID based on Node Name
INSTANCE_ID=$(kubectl get node "$NODE_NAME" -o jsonpath='{.spec.providerID}' | cut -d'/' -f5)

if [ -z "$INSTANCE_ID" ]; then
  echo "Error: Instance ID for node '${NODE_NAME}' not found."
  echo "오류: 노드 '${NODE_NAME}'에 대한 인스턴스 ID를 찾을 수 없습니다."
  exit 1
fi

echo "Instance ID found: $INSTANCE_ID"
# 인스턴스 ID 확인 / Confirm Instance ID

echo "Fetching Network Interface ID for Instance ID: $INSTANCE_ID..."
# 인스턴스 ID로 네트워크 인터페이스 ID 검색 / Get Network Interface ID
NETWORK_INTERFACE_ID=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId" \
  --output text)

if [ "$NETWORK_INTERFACE_ID" == "None" ]; then
  echo "Error: Network Interface for instance '${INSTANCE_ID}' not found."
  echo "오류: 인스턴스 '${INSTANCE_ID}'에 대한 네트워크 인터페이스를 찾을 수 없습니다."
  exit 1
fi

echo "Network Interface ID found: $NETWORK_INTERFACE_ID"
# 네트워크 인터페이스 ID 확인 / Confirm Network Interface ID

echo "Adding Security Group $SG_NAME ($SG_ID) to Network Interface $NETWORK_INTERFACE_ID..."
# 네트워크 인터페이스에 보안 그룹 추가 / Add Security Group to Network Interface
aws ec2 modify-network-interface-attribute \
  --network-interface-id "$NETWORK_INTERFACE_ID" \
  --groups "$SG_ID"

if [ $? -eq 0 ]; then
  echo "Security Group $SG_NAME added successfully to node $NODE_NAME."
  echo "보안 그룹 $SG_NAME이 노드 $NODE_NAME에 성공적으로 추가되었습니다."
else
  echo "Error: Failed to add Security Group to node $NODE_NAME."
  echo "오류: 노드 $NODE_NAME에 보안 그룹 추가 실패."
  exit 1
fi