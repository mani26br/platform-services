###CloudWatchAlerts###

module "cloudwatch_alarms" {
  source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
  alarm_actions = [module.sns_cloudwatchalerts_notifications.sns_topic_arn]
  tags = var.common_tags
}

module "cloudwatch_log_metric_filter" {
  source ="../../terraform-modules/aws/cloudwatch/metric-filter"
  log_group_name = module.cloudwatch_log_group.cloudwatch_log_group_name
  #VPCFlowLogs_log_group_name = module.vpc_flowlog.vpc_flowloggroup_name
  VPCFlowLogs_log_group_name = "eks-vpc-flow-logs"
}

module "cloudwatch_log_group" {
  source = "../../terraform-modules/aws/cloudwatch/log-group"
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