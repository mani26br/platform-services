###CloudWatchAlerts###

# module "cloudwatch_alarms" {
#   source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
#   alarm_actions = [module.sns_cloudwatchalerts_notifications.sns_topic_arn]
#   tags = var.common_tags
# }

module "cloudwatch_log_metric_filter" {
  source ="../../terraform-modules/aws/cloudwatch/metric-filter"
  for_each = local.CloudWatchMetrics
  #log_group_name = module.cloudwatch_log_group.cloudwatch_log_group_name
  #log_group_name = module.vpc_flowlog.vpc_flowloggroup_name
  #log_group_name = "eks-vpc-flow-logs"
  log_group_name = "axleinfo-int-cloudtrail-logs-853931821519-a7aa581f"
  name = "${each.key}"
  metric_transformation_name = "${each.key}"
  pattern = "${each.value}"
  metric_transformation_namespace = var.metric_namespace
}

module "sns_cloudwatchalerts_notifications" {
  source = "../../terraform-modules/aws/sns/sns_topics"
  sns_topic_name = var.cloudwatchalerts_sns_topic_name
  sns_topic_display_name = var.cloudwatchalerts_sns_topic_name
  sns_topic_tags = var.common_tags
  sns_topic_policy = data.aws_iam_policy_document.cwa_sns_topic_policy.json
}

module "sqs_cloudwatchalerts" {
  source = "../../terraform-modules/aws/sqs"
  queue_name = var.cloudwatchalerts_sqs_name
  sqs_queue_url = module.sqs_cloudwatchalerts.base_queue_url
  queue_policy = data.aws_iam_policy_document.cwa_sqs_queue_policy.json
}

module "cwa_sns_topic_subscription"{
  source = "../../terraform-modules/aws/sns/sns_topic_subscription"
  sns_topic_subscription_topic_arn = module.sns_cloudwatchalerts_notifications.sns_topic_arn
  sns_topic_subscription_protocol = "sqs"
  sns_topic_subscription_endpoint = module.sqs_cloudwatchalerts.base_queue_arn
}

# module "cloudwatch_log_group" {
#   source = "../../terraform-modules/aws/cloudwatch/log-group"
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
#   assign_vpc_id = data.aws_vpc.current.id
#   sg_tags = var.common_tags
# }


