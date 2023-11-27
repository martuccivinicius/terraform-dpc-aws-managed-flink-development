variable "kinesis_application_name" {
  description = "The application name"
  type        = string
}

variable "runtime_environment" {
  description = "The runtime environment"
  type        = string
}

variable "role_arn" {
  description = "Role's execution ARN."
  type        = string

}
variable "start_application" {
  description = "Boolean if the application should be started when deployed."
  type        = bool
  default     = false
}

variable "snapshots_enabled" {
  description = "Describes whether snapshots are enabled for a Flink-based application."
  type        = bool
  default     = false
}

variable "file_key" {
  description = "ZIP file's key where the code was deployed in S3."
  type        = string
}

variable "environment_properties" {
  description = "Describes execution properties for a Flink-based application."
  type        = map(any)

}

variable "parallelism" {
  type        = number
  description = "Describes the initial number of parallel tasks that a Flink-based Kinesis Data Analytics application can perform."
  default = 1
}

variable "parallelism_per_kpu" {
  type        = number
  description = "Describes the number of parallel tasks that a Flink-based Kinesis Data Analytics application can perform per Kinesis Processing Unit (KPU) used by the application."
  default = 1
}

variable "auto_scaling_enabled" {
  description = "Describes whether the Kinesis Data Analytics service can increase the parallelism of the application in response to increased throughput."
  default     = false
  type        = bool
}

variable "configuration_checkpoint_configuration" {
  description = "Describes whether the application uses Kinesis Data Analytics' default checkpointing behavior. Valid values: CUSTOM, DEFAULT. Set this attribute to CUSTOM in order for any specified checkpointing_enabled, checkpoint_interval, or min_pause_between_checkpoints attribute values to be effective."
  type = string
  default = "DEFAULT"
  
}

variable "checkpoint_interval" {
  description = " Describes the interval in milliseconds between checkpoint operations."
  type = number
  default = 60000
  
}

variable "checkpointing_enabled" {
  description = "Describes whether checkpointing is enabled for a Flink-based Kinesis Data Analytics application."
  type = bool
  default = true
  
}

variable "min_pause_between_checkpoints" {
  description = "Describes the minimum time in milliseconds after a checkpoint operation completes that a new checkpoint operation can start."
  type = number
  default = 5000
  
}

variable "monitoring_configuration_configuration_type" {
  description = "Describes whether to use the default CloudWatch logging configuration for an application. Valid values: CUSTOM, DEFAULT. Set this attribute to CUSTOM in order for any specified log_level or metrics_level attribute values to be effective."
  type = string
  default = "DEFAULT"
  
}

variable "metrics_level" {
  description = "Describes the granularity of the CloudWatch Logs for an application. Valid values: APPLICATION, OPERATOR, PARALLELISM, TASK"
  type = string
  default = "APPLICATION"
  
}

variable "log_level" {
  description = "Describes the verbosity of the CloudWatch Logs for an application. Valid values: DEBUG, ERROR, INFO, WARN"
  type = string
  default = "INFO"
  
}


variable "tags" {
  description = "A map of tags to apply to all the resources deployed"
  type        = map(any)
  default     = {}
}

variable "bucket_arn" {
  description = "Bucket name."
  type        = string
}

variable "environment" {
  description = "Environment where the application will be deployed."
  type = string
  default = ""
  
}

variable "aws_account_id" {
  description = "AWS Account ID. The default value is obtained using terraform data sources."
  default = ""
}

variable "aws_region" {
  description = "AWS Region. The default value is obtained using terraform data sources."
  default = ""
}