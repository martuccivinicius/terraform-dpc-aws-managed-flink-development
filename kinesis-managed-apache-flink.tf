resource "aws_kinesisanalyticsv2_application" "this" {
  name                   = var.kinesis_application_name
  runtime_environment    = var.runtime_environment
  service_execution_role = var.role_arn
  start_application      = var.start_application



  application_configuration {
    application_snapshot_configuration {
      snapshots_enabled = var.snapshots_enabled
    }
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = var.bucket_arn
          file_key   = var.file_key
        }
      }
      code_content_type = "ZIPFILE"
    }


    environment_properties {
      dynamic "property_group" {
        for_each = var.environment_properties
        content {
          property_group_id = property_group.key

          property_map = property_group.value
        }

      }
    }

    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = var.configuration_checkpoint_configuration
        checkpointing_enabled = var.checkpointing_enabled
        checkpoint_interval = var.checkpoint_interval
        min_pause_between_checkpoints = var.min_pause_between_checkpoints
      }

      monitoring_configuration {
        configuration_type = local.monitoring_configuration_configuration_type
        log_level          = local.log_level
        metrics_level      = local.metrics_level
      }

      parallelism_configuration {
        auto_scaling_enabled = local.auto_scaling_enabled
        configuration_type   = "CUSTOM"
        parallelism          = local.parallelism
        parallelism_per_kpu  = local.parallelism_per_kpu
      }
    }
  }
  cloudwatch_logging_options {
    log_stream_arn = "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/kinesis-analytics/${var.kinesis_application_name}:log-stream:kinesis-analytics-log-stream"
  }

}