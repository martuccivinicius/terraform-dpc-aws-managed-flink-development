data "aws_iam_policy_document" "crawler_default_access" {
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:PutObject",
      "s3:PutObjectVersion",
      "s3:PutObjectVersionAcl",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${module.s3_main_bucket_simple.id}",
      "arn:aws:s3:::${module.s3_main_bucket_simple.id}/*",

    ]
  }

  statement {
    sid    = "LogAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:/aws-glue/*"
    ]
  }

  statement {
    sid    = "KinesisAccess"
    effect = "Allow"
    actions = [
      "kinesis:*"
    ]
    resources = [
      aws_kinesis_stream.kinesis_stream.arn
    ]
  }

  statement {
    sid    = "KDA"
    effect = "Allow"
    actions = [
      "kinesisanalytics:*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "FirehoseAccess"
    effect = "Allow"
    actions = [
      "firehose:*"
    ]
    resources = [
      "arn:aws:firehose:${local.region}:${local.account_id}:deliverystream/${local.kinesis-delivery-stream-name}"
    ]
  }

}

data "aws_iam_policy_document" "crawler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["kinesisanalytics.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = local.role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role_policy.json

  inline_policy {
    name   = local.role_name
    policy = data.aws_iam_policy_document.crawler_default_access.json
  }
}

