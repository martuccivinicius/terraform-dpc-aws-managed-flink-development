resource "aws_kinesis_stream" "kinesis_stream" {
  name             = local.kinesis-stream-name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = local.tags
}