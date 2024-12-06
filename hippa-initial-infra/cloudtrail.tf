resource "aws_cloudtrail" "logs" {
  name                          = "cloud-trail-logs"
  s3_bucket_name                = aws_s3_bucket.cloud_trail_logs.id
  s3_key_prefix                 = "logs"
  include_global_service_events = false
}

resource "aws_s3_bucket" "cloud_trail_logs" {
  bucket        = "cloud-trail-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "cloud_trail_logs_bucket_policy_document" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloud_trail_logs.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloud-trail-logs"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloud_trail_logs.arn}/logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/cloud-trail-logs"]
    }
  }
}
resource "aws_s3_bucket_policy" "cloud_trail_logs_bucket_policy" {
  bucket = aws_s3_bucket.cloud_trail_logs.id
  policy = data.aws_iam_policy_document.cloud_trail_logs_bucket_policy_document.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}