#export ACCOUNT_ID=$(aws sts get-caller-identity --region ap-northeast-2 --output text --query Account)
export eks_version="1.22"
#export publicKeyPath="/home/ec2-user/environment/eksworkshop.pub"
export k_ekscluster_name=k-eksworkshop
export k_public_mgmd_node="frontend"
export k_private_mgmd_node="backend"
export KARPENTER_VERSION="v0.27.0"
echo ${k_ekscluster_name}
echo ${KARPENTER_ACCOUNT_ID}
echo ${k_public_mgmd_node}
echo ${k_private_mgmd_node}
#echo ${CLUSTER_ENDPOINT}
echo ${KARPENTER_VERSION}
echo "export k_ekscluster_name=${k_ekscluster_name}" | tee -a ~/.bash_profile
echo "export k_public_mgmd_node=${k_public_mgmd_node}" | tee -a ~/.bash_profile
echo "export k_private_mgmd_node=${k_private_mgmd_node}" | tee -a ~/.bash_profile
#echo "export k_private_mgmd_node=${CLUSTER_ENDPOINT}" | tee -a ~/.bash_profile
echo "export eks_version=${eks_version}" | tee -a ~/.bash_profile
echo "export KARPENTER_VERSION=${KARPENTER_VERSION}" | tee -a ~/.bash_profile
source ~/.bash_profile
