#!/bin/bash

set -euo pipefail

CLUSTER_NAME=$1
ACCOUNT_ID=$2
REGION="eu-west-1"
OIDC_ISSUER_URL=$(aws eks describe-cluster --name "${CLUSTER_NAME}" --query "cluster.identity.oidc.issuer" --output text)
OIDC_ID=$(echo "${OIDC_ISSUER_URL}" | cut -d '/' -f 5)

# Step 1: Download IAM policy for AWS Load Balancer Controller
echo "Downloading IAM policy for AWS Load Balancer Controller..."
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

# Step 2: Create IAM policy
echo "Creating ALB IAM policy..."
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

# Step 3: Verify OIDC provider
echo "Verifying OIDC provider..."
aws iam list-open-id-connect-providers | grep "${OIDC_ID}" | cut -d "/" -f 4

# Step 4: Create trust policy for the IAM role
echo "Creating trust policy..."
cat > load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}:aud": "sts.amazonaws.com",
                    "oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

# Step 5: Create IAM role
echo "Creating IAM role..."
aws iam create-role \
    --role-name AmazonEKSLoadBalancerControllerRole \
    --assume-role-policy-document file://load-balancer-role-trust-policy.json

# Step 6: Attach policy to IAM role
echo "Attaching policy to IAM role..."
aws iam attach-role-policy \
    --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
    --role-name AmazonEKSLoadBalancerControllerRole

# Step 7: Create Kubernetes ALB service account
echo "Creating Kubernetes ALB service account..."
cat > aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKSLoadBalancerControllerRole
EOF

kubectl apply -f aws-load-balancer-controller-service-account.yaml

# Step 8: Install Cert Manager
echo "Installing Cert Manager..."
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.12.3/cert-manager.yaml

# Step 9: Download AWS Load Balancer Controller manifest
echo "Downloading AWS Load Balancer Controller manifest..."
curl -Lo v2_5_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml

# Step 10: Modify the manifest
echo "Modifying manifest..."
sed -i.bak -e '596,604d' ./v2_5_4_full.yaml
sed -i.bak -e "s|your-cluster-name|${CLUSTER_NAME}|" ./v2_5_4_full.yaml

# Step 11: Apply the AWS Load Balancer Controller manifest
echo "Applying AWS Load Balancer Controller manifest..."
kubectl apply -f v2_5_4_full.yaml

# Step 12: Install ingress class
echo "Installing ingress class..."
curl -Lo v2_5_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_ingclass.yaml
kubectl apply -f v2_5_4_ingclass.yaml

echo "AWS Load Balancer Controller installation complete!"
