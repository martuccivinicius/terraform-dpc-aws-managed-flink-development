## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kinesisanalyticsv2_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesisanalyticsv2_application) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_enabled"></a> [auto\_scaling\_enabled](#input\_auto\_scaling\_enabled) | Describes whether the Kinesis Data Analytics service can increase the parallelism of the application in response to increased throughput. | `bool` | `false` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID. The default value is obtained using terraform data sources. | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region. The default value is obtained using terraform data sources. | `string` | `""` | no |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | Bucket name. | `string` | n/a | yes |
| <a name="input_checkpoint_interval"></a> [checkpoint\_interval](#input\_checkpoint\_interval) | Describes the interval in milliseconds between checkpoint operations. | `number` | `60000` | no |
| <a name="input_checkpointing_enabled"></a> [checkpointing\_enabled](#input\_checkpointing\_enabled) | Describes whether checkpointing is enabled for a Flink-based Kinesis Data Analytics application. | `bool` | `true` | no |
| <a name="input_configuration_checkpoint_configuration"></a> [configuration\_checkpoint\_configuration](#input\_configuration\_checkpoint\_configuration) | Describes whether the application uses Kinesis Data Analytics' default checkpointing behavior. Valid values: CUSTOM, DEFAULT. Set this attribute to CUSTOM in order for any specified checkpointing\_enabled, checkpoint\_interval, or min\_pause\_between\_checkpoints attribute values to be effective. | `string` | `"DEFAULT"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment where the application will be deployed. | `string` | `""` | no |
| <a name="input_environment_properties"></a> [environment\_properties](#input\_environment\_properties) | Describes execution properties for a Flink-based application. | `map(any)` | n/a | yes |
| <a name="input_file_key"></a> [file\_key](#input\_file\_key) | ZIP file's key where the code was deployed in S3. | `string` | n/a | yes |
| <a name="input_kinesis_application_name"></a> [kinesis\_application\_name](#input\_kinesis\_application\_name) | The application name | `string` | n/a | yes |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Describes the verbosity of the CloudWatch Logs for an application. Valid values: DEBUG, ERROR, INFO, WARN | `string` | `"INFO"` | no |
| <a name="input_metrics_level"></a> [metrics\_level](#input\_metrics\_level) | Describes the granularity of the CloudWatch Logs for an application. Valid values: APPLICATION, OPERATOR, PARALLELISM, TASK | `string` | `"APPLICATION"` | no |
| <a name="input_min_pause_between_checkpoints"></a> [min\_pause\_between\_checkpoints](#input\_min\_pause\_between\_checkpoints) | Describes the minimum time in milliseconds after a checkpoint operation completes that a new checkpoint operation can start. | `number` | `5000` | no |
| <a name="input_monitoring_configuration_configuration_type"></a> [monitoring\_configuration\_configuration\_type](#input\_monitoring\_configuration\_configuration\_type) | Describes whether to use the default CloudWatch logging configuration for an application. Valid values: CUSTOM, DEFAULT. Set this attribute to CUSTOM in order for any specified log\_level or metrics\_level attribute values to be effective. | `string` | `"DEFAULT"` | no |
| <a name="input_parallelism"></a> [parallelism](#input\_parallelism) | Describes the initial number of parallel tasks that a Flink-based Kinesis Data Analytics application can perform. | `number` | `1` | no |
| <a name="input_parallelism_per_kpu"></a> [parallelism\_per\_kpu](#input\_parallelism\_per\_kpu) | Describes the number of parallel tasks that a Flink-based Kinesis Data Analytics application can perform per Kinesis Processing Unit (KPU) used by the application. | `number` | `1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Role's execution ARN. | `string` | n/a | yes |
| <a name="input_runtime_environment"></a> [runtime\_environment](#input\_runtime\_environment) | The runtime environment | `string` | n/a | yes |
| <a name="input_snapshots_enabled"></a> [snapshots\_enabled](#input\_snapshots\_enabled) | Describes whether snapshots are enabled for a Flink-based application. | `bool` | `false` | no |
| <a name="input_start_application"></a> [start\_application](#input\_start\_application) | Boolean if the application should be started when deployed. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all the resources deployed | `map(any)` | `{}` | no |

## Outputs

No outputs.
