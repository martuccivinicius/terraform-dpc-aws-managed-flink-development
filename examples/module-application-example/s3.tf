module "s3_main_bucket_simple" {
  source = "github.com/caylent/terraform-dpc-aws-s3-dl.git"

  bucket = local.s3_bucket_name
  tags   = local.tags
}

resource "aws_s3_object" "flink_application_zip" {
  source = "./kinesis-archive-zip/kinesis-stream-to-firehose-windowing.zip"
  bucket = module.s3_main_bucket_simple.id
  key    = "kinesis-archive-zip/kinesis-stream-to-firehose-windowing.zip"

}