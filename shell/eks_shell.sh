#!/bin/bash
# command ./eks_shell.sh
# eks version 1.27

cd ~/environment/
echo "--------------------------"
echo "Export - VPC ID, SubnetID, CIDR, Subnet name"
echo "--------------------------"
export PublicSubnet01_NAME=eksworkshop-PublicSubnet01
export PublicSubnet02_NAME=eksworkshop-PublicSubnet02
export PublicSubnet03_NAME=eksworkshop-PublicSubnet03
export PrivateSubnet01_NAME=eksworkshop-PublicSubnet01
export PrivateSubnet02_NAME=eksworkshop-PublicSubnet02
export PrivateSubnet03_NAME=eksworkshop-PublicSubnet03
export VPC_NAME="eksworkshop"
export VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" | jq -r '.Vpcs[].VpcId')
export PublicSubnet01=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PublicSubnet01_NAME" | jq -r '.Subnets[].SubnetId')
export PublicSubnet02=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PublicSubnet02_NAME" | jq -r '.Subnets[].SubnetId')
export PublicSubnet03=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PublicSubnet03_NAME" | jq -r '.Subnets[].SubnetId')
export PrivateSubnet01=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PrivateSubnet01_NAME" | jq -r '.Subnets[].SubnetId')
export PrivateSubnet02=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PrivateSubnet02_NAME" | jq -r '.Subnets[].SubnetId')
export PrivateSubnet03=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$PrivateSubnet03_NAME" | jq -r '.Subnets[].SubnetId')
echo "export VPC_ID=${VPC_ID}" | tee -a ~/.bash_profile
echo "export PublicSubnet01=${PublicSubnet01}" | tee -a ~/.bash_profile
echo "export PublicSubnet02=${PublicSubnet02}" | tee -a ~/.bash_profile
echo "export PublicSubnet03=${PublicSubnet03}" | tee -a ~/.bash_profile
echo "export PrivateSubnet01=${PrivateSubnet01}" | tee -a ~/.bash_profile
echo "export PrivateSubnet02=${PrivateSubnet02}" | tee -a ~/.bash_profile
echo "export PrivateSubnet03=${PrivateSubnet03}" | tee -a ~/.bash_profile

# eks cluster 환경변수 생성 
echo "--------------------------"
echo "Create environment variables for creating EKS Cluster."
echo "--------------------------"
export EKSCLUSTER_NAME="eksworkshop"
export EKS_VERSION="1.27"
export INSTANCE_TYPE="m6i.xlarge"
export PUBLIC_SELFMGMD_NODE="frontend-workloads"
export PRIVATE_SELFMGMD_NODE="backend-workloads"
export PUBLIC_MGMD_NODE="managed-frontend-workloads"
export PRIVATE_MGMD_NODE="managed-backend-workloads"
# export publicKeyPath="/home/ec2-user/environment/eksworkshop.pub" 
echo "export EKSCLUSTER_NAME=${EKSCLUSTER_NAME}" | tee -a ~/.bash_profile
echo "export EKS_VERSION=${EKS_VERSION}" | tee -a ~/.bash_profile
echo "export INSTANCE_TYPE=${INSTANCE_TYPE}" | tee -a ~/.bash_profile
echo "export PUBLIC_SELFMGMD_NODE=${PUBLIC_SELFMGMD_NODE}" | tee -a ~/.bash_profile
echo "export PRIVATE_SELFMGMD_NODE=${PRIVATE_SELFMGMD_NODE}" | tee -a ~/.bash_profile
echo "export PUBLIC_MGMD_NODE=${PUBLIC_MGMD_NODE}" | tee -a ~/.bash_profile
echo "export PRIVATE_MGMD_NODE=${PRIVATE_MGMD_NODE}" | tee -a ~/.bash_profile
#echo "export publicKeyPath=${publicKeyPath}" | tee -a ~/.bash_profile
source ~/.bash_profile
echo "--------------------------"
echo "Environment variables for EKS Cluster creation have been created in bash_profile."
echo "--------------------------"

