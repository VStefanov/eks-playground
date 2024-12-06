## Description

This folder contains the AWS EKS cluster setup using Terraform Blueprint modules. It also includes modules for installing EKS cluster addons such as the ALB Controller, Metric Server, Cert Manager, and Istio Controller with Gateway. Additionally, it provides examples of various applications using the Istio Controller and Gateway, along with examples for monitoring under the `deployments` folder.

## Deployment Setup

This is a playground repository, and there are no clear deployment steps. It contains Terraform files that can be deployed with Terraform, as well as Kubernetes YAML files that require an already existing EKS cluster. From the deployment folder, you can deploy various files to the cluster.