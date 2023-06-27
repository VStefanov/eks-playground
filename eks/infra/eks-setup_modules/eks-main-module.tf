module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.25.0"

  cluster_name    = "test-cluster"
  cluster_version = "1.25"
  enable_irsa     = true

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    role = {
        capacity_type   = "ON_DEMAND"
        node_group_name = "general"
        instance_types  = ["t2.xlarge"]
        desired_size    = "1"
        min_size        = "1"
        max_size        = "3"
    }
  }
}

provider "kubernetes" {
    host = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode((module.eks_blueprints.eks_cluster_certificate_authority_data))
    
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        args        = ["eks","get-token","--cluster-name",module.eks_blueprints.eks_cluster_id]
    }
}