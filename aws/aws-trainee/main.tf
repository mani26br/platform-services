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
#   log_group_name = [var.cloudtrail_loggroup_name]
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
#   log_group_name = data.aws_cloudwatch_log_groups.vpcflowlogs.log_group_names
#   name = "${each.key}"
#   metric_transformation_name = "${each.key}"
#   pattern = "${each.value}"
#   metric_transformation_namespace = var.metric_namespace
# }

# module "ec2_logs_cloudwatch_alarms" {
#   source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
#   for_each = local.EC2SysLogsMetrics
#   alarm_name = "${each.key}"
#   metric_name = "${each.key}"
#   namespace = var.metric_namespace
#   alarm_actions = [module.sns_cloudwatchalerts_notifications.sns_topic_arn]
#   tags = var.common_tags
# }

# module "ec2_logs_cloudwatch_log_metric_filter" {
#   source ="../../terraform-modules/aws/cloudwatch/log-metric-filter"
#   for_each = local.EC2SysLogsMetrics
#   log_group_name = data.aws_cloudwatch_log_groups.ssm.log_group_names
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

# module "cwa_email_sns_topic_subscription"{
#   source = "../../terraform-modules/aws/sns/sns_topic_subscription"
#   sns_topic_subscription_topic_arn = module.sns_cloudwatchalerts_notifications.sns_topic_arn
#   sns_topic_subscription_protocol = "email"
#   sns_topic_subscription_endpoint = "hyunmin.choi@axleinfo.com"
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

###AWS_Systems_Manager###

# module "ssm_ec2" {
#   source = "../../terraform-modules/aws/ec2/iam_policy_cloudwatch"
# }

# module "ec2_iam_policy" {
#   source = "../../terraform-modules/aws/iam/iam_policy"
#   iam_policy_name = "AmazonSSM_S3_Policy"
#   iam_policy_path = "/"
#   iam_policy_description = "This policy is used to give ec2 access"
#   iam_policy_policy   = data.aws_iam_policy_document.aws_ssm_ec2_policy.json
# }

module "aws_ssm_sgc_s3_bucket" {
  source = "../../terraform-modules/aws/platform-services/s3_bucket"
  bucket = var.aws_ssm_sgc_bucket_name
  policy = data.aws_iam_policy_document.aws_ssm_sgc_s3_policy.json
  region = var.AWS_REGION
  bucket_tags = var.common_tags
}

# module "aws_ssm_s3_bucket" {
#   source = "../../terraform-modules/aws/platform-services/s3_bucket"
#   bucket = var.aws_ssm_bucket_name
#   policy = data.aws_iam_policy_document.aws_ssm_s3_policy.json
#   region = var.AWS_REGION
#   bucket_tags = var.common_tags
# }

# module "ssm_InstallCloudWatchAgent" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
#   association_name = "InstallCloudWatchAgent"
#   name = "AWS-ConfigureAWSPackage"
#   parameters = var.install_cw_agent_parameters
#   target_key_values = var.aws_ssm_instanceIds
#   #schedule_expression = "cron(35 13 ? * THU *)"
#   schedule_expression = "at(2023-08-30T19:45:00)"
#   s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name 
#   s3_key_prefix = "InstallCloudWatchAgent/"
# }

# module "ssm_parameter_store_cwa_config" {
#     source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_parameter"
#     name = "/cpe/cw-agent/infra/config"
#     description = "configuration file for cloudwatch agent"
#     type = "String"
#     value = var.cw_agent_config
#     tags = var.common_tags
# }

# module "ssm_ConfigureCloudWatchAgent" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
#   association_name = "ConfigureCloudWatchAgent"
#   name = "AmazonCloudWatch-ManageAgent"
#   parameters = var.configure_cw_agent_parameters
#   target_key_values = var.aws_ssm_instanceIds
#   #schedule_expression = "cron(38 13 ? * THU *)"
#   schedule_expression = "at(2023-08-30T19:50:00)"
#   s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name
#   s3_key_prefix = "ConfigureCloudWatchAgent/"
# }

# module "ssm_parameter_store_window_cwa_config" {
#     source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_parameter"
#     name = "/cpe/cw-agent/infra/config-window"
#     description = "configuration file for cloudwatch agent"
#     type = "String"
#     value = var.window_cw_agent_config
#     tags = var.common_tags
# }

# module "ssm_Window_ConfigureCloudWatchAgent" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
#   association_name = "Window_ConfigureCloudWatchAgent"
#   name = "AmazonCloudWatch-ManageAgent"
#   parameters = var.configure_window_cw_agent_parameters
#   target_key_values = var.aws_ssm_tags
#   schedule_expression = "at(2023-08-30T19:55:00)"
#   s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name
#   s3_key_prefix = "ConfigureCloudWatchAgent/"
# }

# module "ssm_CloudWatchAgentStatus" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
#   association_name = "CloudWatchAgentStatus"
#   name = "AmazonCloudWatch-ManageAgent"
#   parameters = var.status_cw_agent_parameters
#   target_key_values = var.aws_ssm_instanceIds
#   #schedule_expression = "cron(35 13 ? * THU *)"
#   schedule_expression = "at(2023-08-30T20:00:00)"
#   s3_bucket_name = module.aws_ssm_s3_bucket.s3_bucket_name 
#   s3_key_prefix = "CloudWatchAgentStatus/"
# }

###AWS_Maintenance_Window###

# module "ssm_maintenance_window" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_maintenance_window/window"
#   name            = "test-window"
#   schedule        = "cron(30 20 ? * THU *)"
#   duration        = 2
#   cutoff          = 1
# }

# module "ssm_maintenance_window_target" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_maintenance_window/window_target"
#   window_id = module.ssm_maintenance_window.maintenance_window_id
#   name          = "maintenance-window-target"
#   description   = "This is a maintenance window target"
#   resource_type = "INSTANCE"
#   target_key_values = var.aws_ssm_tags
# }

# module "ssm_maintenance_window_task" {
#   source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_maintenance_window/window_task"
#   window_id = module.ssm_maintenance_window.maintenance_window_id
#   task_arn        = "AWS-ConfigureAWSPackage"
#   task_type       = "RUN_COMMAND"
#   window_target_ids_values = [module.ssm_maintenance_window_target.maintenance_window_target_id]
#   output_s3_bucket = module.aws_ssm_s3_bucket.s3_bucket_name
#   output_s3_key_prefix = "MaintenanceWindowinstall/"
#   service_role_arn = module.ssm_ec2.iam_role_arn
#   #parameter = local.MaintenanceWindow
#   #notification_arn = "arn:aws:sns:us-west-2:123456789012:my-topic"
# }

###IAM_USER###
# data "aws_iam_policy_document" "lb_ro" {
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:Describe*"]
#     resources = ["*"]
#   }
# }

# module "IAM_UserProgrammaticAccess" {
#   source = "../../terraform-modules/aws/iam/iam_user"
#   iam_user_name = "CPE-test-user"
#   policy = data.aws_iam_policy_document.lb_ro.json
#   iam_user_tags = var.common_tags
# }

# output "access" {
#   value = module.IAM_UserProgrammaticAccess.secret
# }

###Security Groups###

module "SecurityGroup" {
  source = "../../terraform-modules/aws/securitygroup"
  for_each = toset(data.aws_vpcs.current.ids)
  sg_name = "allow-nih-http-sg"
  sg_description = "Security groups for ABAC within NIH CIDR block for http access"
  sg_ingress = var.sg_ingress_http
  sg_egress = var.sg_egress
  assign_vpc_id = "${each.key}"
  sg_tags = var.common_tags
}


