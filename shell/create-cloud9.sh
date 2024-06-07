#create-cloud9.sh

C9_IAM_ROLE_NAME="eksworkshop-admin"
C9_IAM_Profile_NAME="eksworkshop-admin"
C9_NAME="MyCloud9"
C9_INSTANCE_TYPE="t3.large"

aws iam create-role --path / \
--role-name ${C9_IAM_ROLE_NAME} \
--description "Role used by Cloud9 environment" \
--assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"ec2.amazonaws.com\"]},\"Action\":[\"sts:AssumeRole\"]}]}"

aws iam attach-role-policy --role-name ${C9_IAM_ROLE_NAME} --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam create-instance-profile --instance-profile-name ${C9_IAM_Profile_NAME}

aws iam add-role-to-instance-profile --instance-profile-name ${C9_IAM_Profile_NAME} --role-name ${C9_IAM_ROLE_NAME}

#aws cloud9 create-environment-ec2 --name ${C9_NAME} --description ${C9_NAME} --instance-type "${C9_INSTANCE_TYPE}" --image-id resolve:ssm:/aws/service/cloud9/amis/amazonlinux-1-x86_64 --region $AWS_REGION --automatic-stop-time-minutes 0
aws cloud9 create-environment-ec2 --name ${C9_NAME} --description ${C9_NAME} --instance-type "${C9_INSTANCE_TYPE}" --image-id resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2023-x86_64 --region $AWS_REGION --automatic-stop-time-minutes 0

C9_IDS=$(aws cloud9 list-environments | jq -r '.environmentIds | join(" ")')
CLOUD9_EC2=$(aws cloud9 describe-environments --environment-ids "${C9_IDS}" | jq -r '.environments[] | select(.name == "MyCloud9") | .id')

sleep 60

CLOUD9_EC2_ID=$(aws ec2 describe-instances --region "${AWS_REGION}" --filters "Name=tag:aws:cloud9:environment,Values=${CLOUD9_EC2}" --query "Reservations[*].Instances[*].InstanceId" --output text)

aws ec2 associate-iam-instance-profile --instance-id "${CLOUD9_EC2_ID}" --iam-instance-profile Name=${C9_IAM_Profile_NAME} --region "${AWS_REGION}"

# Disable - AWS Managed temporary credentials
aws cloud9 update-environment --environment-id "${CLOUD9_EC2}" --managed-credentials-action DISABLE

# aws cloud9 create-environment-membership --environment-id $CLOUD9_ENV_ID --user-arn arn:aws:iam::$AWS_ACCOUNT_ID_VALUE:root --permissions read-write

log_text "Success" "Cloud9 Environment created successfully..."

