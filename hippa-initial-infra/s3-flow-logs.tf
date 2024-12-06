module "s3_audit_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "audit-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}