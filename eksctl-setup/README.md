## Deployment Steps
This documentation provides a comprehensive guide to setting up an AWS EKS cluster with a dedicated VPC and customized networking configurations. The setup enables multitenancy, incorporates advanced network policy management for enhanced security, and integrates the AWS Load Balancer (ALB) Controller. This approach ensures secure workload isolation and serves as a robust foundation for deploying applications to EKS.

**Create EKS Cluster**

```
eksctl create cluster -f eks-cluster.yaml
```

**Setup Cluster WebIdentity**

```
eksctl utils associate-iam-oidc-provider --cluster=<name> --region=eu-west-1 --approve`
```

**Install Calico CNI**

First you need to install the operator
```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
```

Then configure the Calico installation

```
kubectl apply -f calico-installation.yaml
```

This configuration installs Calico in policy-only mode while retaining the Amazon VPC CNI as the primary networking plugin. The Amazon VPC CNI allocates ENIs to pods directly in the VPC, giving each pod an IP address from the VPC CIDR range. While this approach lacks the flexibility of Calico’s overlay networking for pod IP segregation, it is ideal for scenarios where AWS-native performance and integration are prioritized. By combining the two, we benefit from advanced multi-tenancy and network policy management provided by Calico, while maintaining the performance and simplicity of the Amazon VPC CNI.

**ALB Ingress Controller Installation**

Run the following bash script:

```
alb-ingress-installation.sh
```

## Multitenant Deployments Example

The Kubernetes deployment files follow AWS documentation, providing an overview of how to achieve multitenancy and network policy management using the AWS native VPC CNI:

https://docs.aws.amazon.com/eks/latest/userguide/network-policy-stars-demo.html