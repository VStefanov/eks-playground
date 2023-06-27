module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-clusters"
  cluster_version = "1.24"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.eks_vpc.vpc_id
  subnet_ids               = module.eks_vpc.private_subnets
  control_plane_subnet_ids = module.eks_vpc.private_subnets

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 4
      desired_size = 1

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
    } 
  }

  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

output "cluster_name" {
  value = module.eks_cluster.cluster_id
}

output "kubeconfig" {
  value = module.eks_cluster.aws_auth_configmap_yaml
}