module "kinesis_managed_flink" {
  source                   = "../.."
  kinesis_application_name = "martucci-dpc-module-flink"
  runtime_environment      = "FLINK-1_15"
  role_arn                 = aws_iam_role.role.arn
  bucket_arn               = module.s3_main_bucket_simple.arn
  file_key                 = aws_s3_object.flink_application_zip.key
  environment              = "development"
  start_application = true
  tags              = local.tags


  environment_properties = {
    "kinesis.analytics.flink.run.options" : {
      python  = "kinesis-stream-to-firehose-windowing/main.py",
      jarfile = "kinesis-stream-to-firehose-windowing/lib/aws-kinesis-analytics-python-apps-1-15-4.jar"
    },
    "consumer.config.0" : {
      "input.stream.name"    = aws_kinesis_stream.kinesis_stream.name
      "flink.stream.initpos" = "LATEST"
      "aws.region"           = "us-east-1"
    },
    "producer.config.0" : {
      "output.stream.name" = aws_kinesis_firehose_delivery_stream.this.name
      "aws.region"         = "us-east-1"
    }


  }

}