#!/bin/bash

# EC2 인스턴스를 검색하기 위한 태그 값 / Tag value to filter EC2 instances
TAG_NAME="eksworkshop-managed-ng-public-01-Node"
PORT="30080"

echo "Fetching Public IPs for instances with tag: Name=$TAG_NAME..."

# EC2 인스턴스의 Public IP 주소 가져오기 / Get Public IP addresses of instances with the specified tag
PUBLIC_IPS=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=${TAG_NAME}" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text)

if [ -z "$PUBLIC_IPS" ]; then
  echo "No Public IPs found for tag: Name=$TAG_NAME"
  echo "태그 $TAG_NAME에 대한 Public IP를 찾을 수 없습니다."
  exit 1
fi

echo "Public IPs with port $PORT:"
# 각 IP 주소 뒤에 포트를 붙여 출력 / Append the port to each IP address and print
for IP in $PUBLIC_IPS; do
  echo "${IP}:${PORT}"
done