locals {
  s3_bucket_name               = "dpc-managed-flink-example-martucci"
  role_name                    = "dpc-managed-flink-example"
  kinesis-stream-name          = "ks-managed-flink-example"
  kinesis-delivery-stream-name = "kds-managed-flink-example"
  account_id                   = data.aws_caller_identity.current.account_id
  user_id                      = replace(regex(":.*@.*", data.aws_caller_identity.current.user_id), ":", "")
  region                       = "us-east-1"
  tags                         = { "caylent:owner" = local.user_id }
  aws_region                   = data.aws_region.current.name
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}