module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.25.0"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  enable_amazon_eks_aws_ebs_csi_driver = true

  #enable_aws_efs_csi_driver      = true
  #aws_efs_csi_driver_helm_config = {
  #  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  #  version    = "2.4.0"
  #  namespace  = "kube-system"
  #}

  enable_aws_load_balancer_controller = true

  enable_metrics_server = true

  enable_cert_manager = true
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }
}