#!/bin/bash
# command ./eks_shell.sh
# eks version 1.25

cd ~/environment/
#VPC ID export
export eksworkshop01_vpc_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksworkshop01 | jq -r '.Vpcs[].VpcId')
echo $eksworkshop01_vpc_ID

#Subnet ID, CIDR, Subnet Name export
aws ec2 describe-subnets --filter Name=vpc-id,Values=$vpc_ID | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)'
echo $eksworkshop01_vpc_ID > vpc_subnet.txt
aws ec2 describe-subnets --filter Name=vpc-id,Values=$vpc_ID | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' >> eksworkshop01_vpc_subnet.txt
cat eksworkshop01_vpc_subnet.txt

# VPC, Subnet ID 환경변수 저장 
export eksworkshop01_PublicSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PublicSubnet01' | jq -r '.Subnets[].SubnetId')
export eksworkshop01_PublicSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PublicSubnet02' | jq -r '.Subnets[].SubnetId')
export eksworkshop01_PublicSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PublicSubnet03' | jq -r '.Subnets[].SubnetId')
export eksworkshop01_PrivateSubnet01=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PrivateSubnet01' | jq -r '.Subnets[].SubnetId')
export eksworkshop01_PrivateSubnet02=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PrivateSubnet02' | jq -r '.Subnets[].SubnetId')
export eksworkshop01_PrivateSubnet03=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=eksworkshop01-PrivateSubnet03' | jq -r '.Subnets[].SubnetId')
echo "export eksworkshop01_vpc_ID=${eksworkshop01_vpc_ID}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PublicSubnet01=${eksworkshop01_PublicSubnet01}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PublicSubnet02=${eksworkshop01_PublicSubnet02}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PublicSubnet03=${eksworkshop01_PublicSubnet03}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PrivateSubnet01=${eksworkshop01_PrivateSubnet01}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PrivateSubnet02=${eksworkshop01_PrivateSubnet02}" | tee -a ~/.bash_profile
echo "export eksworkshop01_PrivateSubnet03=${eksworkshop01_PrivateSubnet03}" | tee -a ~/.bash_profile

# eks cluster 환경변수 생성 
export ekscluster_name01="eksworkshop01"
export eks_version="1.25"
export instance_type="m5.xlarge"
export eks01_public_mgmd_node="eks01-managed-frontend-workloads"
export eks01_private_mgmd_node="eks01-managed-backend-workloads"
export publicKeyPath="/home/ec2-user/environment/eksworkshop.pub"

echo ${ekscluster_name01}
echo ${AWS_REGION}
echo ${eks_version}
echo ${eksworkshop01_PublicSubnet01}
echo ${eksworkshop01_PublicSubnet02}
echo ${eksworkshop01_PublicSubnet03}
echo ${eksworkshop01_PrivateSubnet01}
echo ${eksworkshop01_PrivateSubnet02}
echo ${eksworkshop01_PrivateSubnet03}
echo ${MASTER_ARN}
echo ${instance_type}
echo ${public_mgmd_node}
echo ${private_mgmd_node}
echo ${publicKeyPath}

# ekscluster name, version, instance type, nodegroup label 환경변수 저장.  
echo "export ekscluster_name01=${ekscluster_name01}" | tee -a ~/.bash_profile
echo "export eks_version=${eks_version}" | tee -a ~/.bash_profile
echo "export instance_type=${instance_type}" | tee -a ~/.bash_profile
echo "export eks01_public_mgmd_node=${eks01_public_mgmd_node}" | tee -a ~/.bash_profile
echo "export eks01_private_mgmd_node=${eks01_private_mgmd_node}" | tee -a ~/.bash_profile
echo "export publicKeyPath=${publicKeyPath}" | tee -a ~/.bash_profile

source ~/.bash_profile

