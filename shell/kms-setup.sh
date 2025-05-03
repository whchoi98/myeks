#!/bin/bash

# 🔐 EKS용 KMS 키 생성 및 alias 등록
set -e

ALIAS_NAME="alias/eksworkshop"

echo "------------------------------------------------------"
echo "🔑 KMS alias: $ALIAS_NAME"
echo "------------------------------------------------------"

# 이미 alias가 존재하는지 확인
EXISTING_ARN=$(aws kms describe-key --key-id "$ALIAS_NAME" --query KeyMetadata.Arn --output text 2>/dev/null || true)

if [ -z "$EXISTING_ARN" ]; then
  echo "📦 새 KMS 키를 생성하고 alias를 지정합니다..."

  # 새 KMS 키 생성
  KEY_ARN=$(aws kms create-key --query KeyMetadata.Arn --output text)
  
  # alias 등록
  aws kms create-alias --alias-name "$ALIAS_NAME" --target-key-id "$KEY_ARN"
else
  echo "✅ 이미 존재하는 alias입니다. 생성된 ARN을 사용합니다."
  KEY_ARN="$EXISTING_ARN"
fi

# 환경변수 등록
echo "📍 MASTER_ARN: $KEY_ARN"
export MASTER_ARN="$KEY_ARN"

# ~/.bash_profile에 추가 (중복 방지)
if ! grep -q "export MASTER_ARN=" ~/.bash_profile; then
  echo "export MASTER_ARN=${MASTER_ARN}" | tee -a ~/.bash_profile
fi

echo "✅ 환경 변수 설정 완료. 새 셸을 열거나 'source ~/.bash_profile'을 실행하세요."