resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = local.kinesis-delivery-stream-name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.role.arn
    bucket_arn         = module.s3_main_bucket_simple.arn
    buffering_size     = 64
    buffering_interval = 60
    dynamic_partitioning_configuration {
      enabled = "false"
    }

    prefix              = "${local.kinesis-delivery-stream-name}/data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "${local.kinesis-delivery-stream-name}/errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"

    #compression_format = "Snappy"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.kinesis-delivery-stream-name}"
      log_stream_name = "logs"
    }
  }

  tags = local.tags
}