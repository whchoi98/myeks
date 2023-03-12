### VPC 정보 
cd ~/environment/
#VPC ID export
export k_vpc_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=eksworkshop --region ap-northeast-2| jq -r '.Vpcs[].VpcId')
echo $k_vpc_ID

#Subnet ID, CIDR, Subnet Name export
aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)'
aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' >> k_vpc_subnet.txt

# VPC, Subnet ID 환경변수 저장 
export k_PublicSubnet01=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PublicSubnet01/{print $1}')
export k_PublicSubnet02=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PublicSubnet02/{print $1}')
export k_PublicSubnet03=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PublicSubnet03/{print $1}')
export k_PrivateSubnet01=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PrivateSubnet01/{print $1}')
export k_PrivateSubnet02=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PrivateSubnet02/{print $1}')
export k_PrivateSubnet03=$(aws ec2 describe-subnets --filter Name=vpc-id,Values=$k_vpc_ID --region ap-northeast-2 | jq -r '.Subnets[]|.SubnetId+" "+.CidrBlock+" "+(.Tags[]|select(.Key=="Name").Value)' | awk '/eksworkshop-PrivateSubnet03/{print $1}')
echo "export k_vpc_ID=${k_vpc_ID}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet01=${k_PublicSubnet01}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet02=${k_PublicSubnet02}" | tee -a ~/.bash_profile
echo "export k_PublicSubnet03=${k_PublicSubnet03}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet01=${k_PrivateSubnet01}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet02=${k_PrivateSubnet02}" | tee -a ~/.bash_profile
echo "export k_PrivateSubnet03=${k_PrivateSubnet03}" | tee -a ~/.bash_profile
#echo "export publicKeyPath=${publicKeyPath}" | tee -a ~/.bash_profile
source ~/.bash_profile
