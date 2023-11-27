locals {
    snapshots_enabled = var.environment == "development" ? false : var.environment == "production" ? true : var.snapshots_enabled
    monitoring_configuration_configuration_type = var.environment == "development" ? "CUSTOM" : var.environment == "production" ? "CUSTOM" : var.monitoring_configuration_configuration_type
    metrics_level  = var.environment == "development" ? "APPLICATION" : var.environment == "production" ? "TASK" : var.metrics_level
    log_level = var.environment == "development" ? "INFO" : var.environment == "production" ? "INFO" : var.log_level
    parallelism = var.environment == "development" ? 1 : var.environment == "production" ? 12 : var.parallelism
    parallelism_per_kpu = var.environment == "development" ? 1 : var.environment == "production" ? 1 : var.parallelism_per_kpu
    auto_scaling_enabled = var.environment == "development" ? false : var.environment == "production" ? true : var.auto_scaling_enabled
    aws_account_id = var.aws_account_id == "" ? data.aws_caller_identity.current.account_id : var.aws_account_id
    aws_region = var.aws_region == "" ? data.aws_region.current.name : var.aws_region
} 
