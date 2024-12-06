module "dev_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev-vpc"
  cidr = "10.20.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]

  enable_flow_log             = true
  flow_log_destination_arn    = module.s3_audit_bucket.s3_bucket_arn
  flow_log_file_format        = "parquet"
  flow_log_destination_type   = "s3"
  flow_log_per_hour_partition = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}