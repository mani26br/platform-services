###CloudWatchAlerts###

# module "cloudwatch_alarms" {
#   source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
#   for_each = local.CloudTrailMetrics
#   alarm_name = "${each.key}"
#   metric_name = "${each.key}"
#   namespace = var.metric_namespace
#   alarm_actions = [module.sns_cloudwatchalerts_notifications.sns_topic_arn]
#   tags = var.common_tags
# }

# module "cloudwatch_log_metric_filter" {
#   source ="../../terraform-modules/aws/cloudwatch/log-metric-filter"
#   for_each = local.CloudTrailMetrics
#   log_group_name = var.cloudtrail_loggroup_name
#   name = "${each.key}"
#   metric_transformation_name = "${each.key}"
#   pattern = "${each.value}"
#   metric_transformation_namespace = var.metric_namespace
# }

# module "vpc_flowlogs_cloudwatch_alarms" {
#   source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
#   for_each = local.VPCFlowLogsMetrics
#   alarm_name = "${each.key}"
#   metric_name = "${each.key}"
#   namespace = var.metric_namespace
#   alarm_actions = [module.sns_cloudwatchalerts_notifications.sns_topic_arn]
#   tags = var.common_tags
# }

# module "vpc_flowlogs_cloudwatch_log_metric_filter" {
#   source ="../../terraform-modules/aws/cloudwatch/log-metric-filter"
#   for_each = local.VPCFlowLogsMetrics
#   #log_group_name = module.vpc_flowlog[data.aws_vpcs.current.ids[0]].vpc_flowloggroup_name
#   log_group_name = local.VPCFlowLogGroupNames
#   name = "${each.key}"
#   metric_transformation_name = "${each.key}"
#   pattern = "${each.value}"
#   metric_transformation_namespace = var.metric_namespace
# }

# module "sns_cloudwatchalerts_notifications" {
#   source = "../../terraform-modules/aws/sns/sns_topics"
#   sns_topic_name = var.cloudwatchalerts_sns_topic_name
#   sns_topic_display_name = var.cloudwatchalerts_sns_topic_name
#   sns_topic_tags = var.common_tags
#   sns_topic_policy = data.aws_iam_policy_document.cwa_sns_topic_policy.json
# }

# module "sqs_cloudwatchalerts" {
#   source = "../../terraform-modules/aws/sqs"
#   queue_name = var.cloudwatchalerts_sqs_name
#   sqs_queue_url = module.sqs_cloudwatchalerts.base_queue_url
#   queue_policy = data.aws_iam_policy_document.cwa_sqs_queue_policy.json
# }

# module "cwa_sns_topic_subscription"{
#   source = "../../terraform-modules/aws/sns/sns_topic_subscription"
#   sns_topic_subscription_topic_arn = module.sns_cloudwatchalerts_notifications.sns_topic_arn
#   sns_topic_subscription_protocol = "sqs"
#   sns_topic_subscription_endpoint = module.sqs_cloudwatchalerts.base_queue_arn
# }

###VPC_flow_log###

# module "flowlogrole" {
#   source = "../../terraform-modules/aws/iam/iam_role"
#   iam_role_name = var.flowlogrole_name
#   iam_role_assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role_policy.json
#   iam_role_policy_name = var.flowlogrole_policy_name
#   iam_role_policy = data.aws_iam_policy_document.flow_log_role_policy.json
# }

# module "vpc_flowlog" {
#   source = "../../terraform-modules/aws/platform-services/vpc_flowlog"
#   for_each = toset(data.aws_vpcs.current.ids)
#   vpc_id = "${each.key}"
#   flow_log_role_arn = module.flowlogrole.iam_role_arn
#   environment = var.common_tags["environment"]
#   cloudwatch_log_tags = var.common_tags
#   vpc_flow_log_tags = var.common_tags
# }

###Security Groups###

# module "SecurityGroup" {
#   source = "../../terraform-modules/aws/securitygroup"
#   for_each = toset(data.aws_vpcs.current.ids)
#   sg_name = var.sg_name
#   sg_description = var.sg_description
#   sg_ingress = var.sg_ingress
#   sg_egress = var.sg_egress
#   assign_vpc_id = "${each.key}"
#   sg_tags = var.common_tags
# }

###AWS_Systems_Manager###

module "iam_policy" {
  source = "../../terraform-modules/aws/iam/iam_policy_cloudwatch"
}

module "aws_ssm_s3_bucket" {
  source = "../../terraform-modules/aws/platform-services/s3_bucket"
  bucket = var.aws_ssm_bucket_name
  policy = data.aws_iam_policy_document.aws_ssm_s3_policy.json
  region = var.AWS_REGION
  bucket_tags = var.common_tags
}

module "ssm_InstallCloudWatchAgent" {
  source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
  name = "AWS-ConfigureAWSPackage"
  parameters = var.install_cw_agent_parameters
  target_key_values = var.aws_ssm_tags
  schedule_expression = "cron(35 13 ? * THU *)"
  s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name  
}

# module "ssm_parameter_store_cwa_config" {
#     source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_parameter"
#     name = var.ssm_parameter_store_name
#     description = "configuration file for cloudwatch agent"
#     type = "String"
#     value = var.cw_agent_config
#     tags = var.common_tags
# }

# module "ssm_ConfigureCloudWatchAgent" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
#   name = "AmazonCloudWatch-ManageAgent"
#   parameters = var.configure_cw_agent_parameters
#   target_key_values = var.aws_ssm_tags
#   schedule_expression = "cron(38 13 ? * THU *)"
#   s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name
# }

# module "ssm_maintenance_window" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_maintenance_window"

#   name            = "test-window"
#   schedule        = "cron(30 19 ? * FRI *)"
#   duration        = 2
#   cutoff          = 1
#   task_arn        = "AWS-ConfigureAWSPackage"
#   task_type       = "RUN_COMMAND"
#   target_key_values = var.aws_ssm_tags
#   output_s3_bucket = module.aws_ssm_s3_bucket.s3_bucket_name
#   service_role_arn = module.iam_policy.iam_role_arn
#   #notification_arn = "arn:aws:sns:us-west-2:123456789012:my-topic"
#   #parameter       = var.install_cw_agent_parameters
# }