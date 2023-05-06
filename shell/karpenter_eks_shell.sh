#!/bin/bash
# command ./karpenter_eks_shell.sh

cd ~/environment/
#VPC ID export
export k_vpc_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksworkshop --region ap-northeast-1 | jq -r '.Vpcs[].VpcId')
echo $k_vpc_ID

#Subnet ID, CIDR, Subnet Name export
aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-1 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)'
aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-1| jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' >> k_vpc_subnet.txt
cat k_vpc_subnet.txt

# VPC, Subnet ID 환경변수 저장 
export k_PublicSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PublicSubnet01' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
export k_PublicSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PublicSubnet02' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
export k_PublicSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PublicSubnet03' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
export k_PrivateSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PrivateSubnet01' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
export k_PrivateSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PrivateSubnet02' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
export k_PrivateSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop-PrivateSubnet03' --region ap-northeast-1 | jq -r '.Subnets[].SubnetId')
echo "export k_vpc_ID=${k_vpc_ID}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet01=${k_PublicSubnet01}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet02=${k_PublicSubnet02}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet03=${k_PublicSubnet03}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet01=${k_PrivateSubnet01}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet02=${k_PrivateSubnet02}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet03=${k_PrivateSubnet03}" | tee -a ~/.bash_profile

# eks cluster 환경변수 생성 
export k_ekscluster_name="eksworkshop"
export eks_version="1.22"
export instance_type="m5.xlarge"
export public_selfmgmd_node="frontend-workloads"
export private_selfmgmd_node="backend-workloads"
export public_mgmd_node="managed-frontend-workloads"
export private_mgmd_node="managed-backend-workloads"
export publicKeyPath="/home/ec2-user/environment/eksworkshop.pub"

echo ${ekscluster_name}
echo ${AWS_REGION}
echo ${eks_version}
echo ${PublicSubnet01}
echo ${PublicSubnet02}
echo ${PublicSubnet03}
echo ${PrivateSubnet01}
echo ${PrivateSubnet02}
echo ${PrivateSubnet03}
echo ${MASTER_ARN}
echo ${instance_type}
echo ${public_selfmgmd_node}
echo ${private_selfmgmd_node}
echo ${public_mgmd_node}
echo ${private_mgmd_node}
echo ${publicKeyPath}

# ekscluster name, version, instance type, nodegroup label 환경변수 저장.  
echo "export ekscluster_name=${ekscluster_name}" | tee -a ~/.bash_profile
echo "export eks_version=${eks_version}" | tee -a ~/.bash_profile
echo "export instance_type=${instance_type}" | tee -a ~/.bash_profile
echo "export public_selfmgmd_node=${public_selfmgmd_node}" | tee -a ~/.bash_profile
echo "export private_selfmgmd_node=${private_selfmgmd_node}" | tee -a ~/.bash_profile
echo "export public_mgmd_node=${public_mgmd_node}" | tee -a ~/.bash_profile
echo "export private_mgmd_node=${private_mgmd_node}" | tee -a ~/.bash_profile
echo "export publicKeyPath=${publicKeyPath}" | tee -a ~/.bash_profile

source ~/.bash_profile

