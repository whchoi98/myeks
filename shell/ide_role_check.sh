#!/bin/bash

echo "------------------------------------------------------"
echo "🔐 IDE 터미널의 IAM 역할 유효성 검사 중..."
echo "------------------------------------------------------"

# get-caller-identity 호출
CALLER_ARN=$(aws sts get-caller-identity --region ap-northeast-2 --query Arn --output text)

# 결과 출력
echo "📛 현재 Caller ARN:"
echo "$CALLER_ARN"

# 역할 검증 (ec2vscodeserver가 포함되어야 함)
#if echo "$CALLER_ARN" | grep -q "ec2vscodeserver"; then
if echo "$CALLER_ARN" | grep -q "mgmtvpc-SSMRole"; then

  echo "✅ IAM Role 유효: mgmtvpc-SSMRole 역할이 감지되었습니다."
else
  echo "❌ IAM Role 비정상: mgmtvpc-SSMRole 역할이 아닙니다!"
fi

echo "------------------------------------------------------"
