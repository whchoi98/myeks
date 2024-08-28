#!/bin/bash
# command ./eksctl_shell.sh
# eksctl yaml 실행

source ~/.bash_profile
cat << EOF > ~/environment/myeks/eksworkshop.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: ${EKSCLUSTER_NAME}
  region: ${AWS_REGION}
  version: "${EKS_VERSION}"
  tags:
    karpenter.sh/discovery: ${EKSCLUSTER_NAME}
vpc: 
  id: ${VPC_ID}
  subnets:
    public:
      PublicSubnet01:
        az: ${AWS_REGION}a
        id: ${PublicSubnet01}
      PublicSubnet02:
        az: ${AWS_REGION}b
        id: ${PublicSubnet02}
      PublicSubnet03:
        az: ${AWS_REGION}c
        id: ${PublicSubnet03}
    private:
      PrivateSubnet01:
        az: ${AWS_REGION}a
        id: ${PrivateSubnet01}
      PrivateSubnet02:
        az: ${AWS_REGION}b
        id: ${PrivateSubnet02}
      PrivateSubnet03:
        az: ${AWS_REGION}c
        id: ${PrivateSubnet03}
secretsEncryption:
  keyARN: ${MASTER_ARN}

nodeGroups:
  - name: ng-public-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PUBLIC_SELFMGMD_NODE}"
    iam:
      attachPolicyARNs:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true

  - name: ng-private-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PrivateSubnet01}
      - ${PrivateSubnet02}
      - ${PrivateSubnet03}
    desiredCapacity: 3
    privateNetworking: true
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PRIVATE_SELFMGMD_NODE}"
    iam:
      attachPolicyARNs:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true

managedNodeGroups:
  - name: managed-ng-public-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PublicSubnet01}
      - ${PublicSubnet02}
      - ${PublicSubnet03}
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PUBLIC_MGMD_NODE}"
    iam:
      attachPolicyARNs:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true
        
  - name: managed-ng-private-01
    instanceType: ${INSTANCE_TYPE}
    subnets:
      - ${PrivateSubnet01}
      - ${PrivateSubnet02}
      - ${PrivateSubnet03}
    desiredCapacity: 3
    privateNetworking: true
    minSize: 3
    maxSize: 6
    volumeSize: 50
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${PRIVATE_MGMD_NODE}"
    iam:
      attachPolicyARNs:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true        
cloudWatch:
    clusterLogging:
        enableTypes: ["api", "audit", "authenticator", "controllerManager", "scheduler"]
iam:
  withOIDC: true
  podIdentityAssociations:
  - namespace: "${KARPENTER_NAMESPACE}"
    serviceAccountName: karpenter
    roleName: ${EKSCLUSTER_NAME}-karpenter
    permissionPolicyARNs:
    - arn:${AWS_PARTITION}:iam::${ACCOUNT_ID}:policy/KarpenterControllerPolicy-${EKSCLUSTER_NAME}
iamIdentityMappings:
- arn: "arn:${AWS_PARTITION}:iam::${ACCOUNT_ID}:role/KarpenterNodeRole-${EKSCLUSTER_NAME}"
  username: system:node:{{EC2PrivateDNSName}}
  groups:
  - system:bootstrappers
  - system:nodes
  
addons:
- name: vpc-cni
  attachPolicyARNs:
    - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
- name: coredns
  version: latest
- name: kube-proxy
  version: latest
- name: aws-ebs-csi-driver
  wellKnownPolicies:
    ebsCSIController: true
- name: eks-pod-identity-agent
EOF
