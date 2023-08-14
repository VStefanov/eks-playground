module "mgmt_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "management-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.100.0/24", "10.10.200.0/24"]

  enable_flow_log             = true
  flow_log_destination_arn    = module.s3_audit_bucket.s3_bucket_arn
  flow_log_file_format        = "parquet"
  flow_log_destination_type   = "s3"
  flow_log_per_hour_partition = true

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Environment = "management"
  }
}