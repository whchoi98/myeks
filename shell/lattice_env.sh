
#!/bin/bash

echo "export AWS_REGION="us-west-2" | tee -a ~/.bash_profile
echo "export LATTICE_DOMAIN_NAME="lattice.io" | tee -a ~/.bash_profile
echo "export CLUSTER1_NAME="c1" | tee -a ~/.bash_profile
echo "export VPC1_NAME='LatticeWorkshop Clients VPC' | tee -a ~/.bash_profile
echo "export VPC1_FILTER="Name=tag:Name,Values='$VPC1_NAME'" | tee -a ~/.bash_profile
echo "export CLUSTER2_NAME="c2" | tee -a ~/.bash_profile
echo "export VPC2_NAME='LatticeWorkshop Rates VPC' | tee -a ~/.bash_profile
echo "export VPC2_FILTER="Name=tag:Name,Values='$VPC2_NAME'" | tee -a ~/.bash_profile
echo "export ASSETS_HOSTNAME="assets-${CLUSTER1_NAME}" | tee -a ~/.bash_profile
echo "export CART_HOSTNAME="cart-${CLUSTER1_NAME}" | tee -a ~/.bash_profile
echo "export CATALOG_HOSTNAME="catalog-${CLUSTER1_NAME}" | tee -a ~/.bash_profile
echo "export CHECKOUT_HOSTNAME="checkout-${CLUSTER2_NAME}" | tee -a ~/.bash_profile
echo "export ASSETS_FQDN="${ASSETS_HOSTNAME}.${LATTICE_DOMAIN_NAME}" | tee -a ~/.bash_profile
echo "export CART_FQDN="${CART_HOSTNAME}.${LATTICE_DOMAIN_NAME}" | tee -a ~/.bash_profile
echo "export CATALOG_FQDN="${CATALOG_HOSTNAME}.${LATTICE_DOMAIN_NAME}" | tee -a ~/.bash_profile
echo "export CHECKOUT_FQDN="${CHECKOUT_HOSTNAME}.${LATTICE_DOMAIN_NAME}" | tee -a ~/.bash_profile
echo "export EKS_VERSION="1.25" | tee -a ~/.bash_profile
echo "export NODE_INSTANCE_TYPE="m5.xlarge" | tee -a ~/.bash_profile
echo "export ACCOUNT_ID=$(aws sts get-caller-identity --region ap-northeast-2 --output text --query Account)" | tee -a ~/.bash_profile


