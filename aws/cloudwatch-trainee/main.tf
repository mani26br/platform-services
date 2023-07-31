module "cloudwatch_alarms" {
  source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
  alarm_actions = [module.sns_topic.sns_topic_arn]
}

module "cloudwatch_log_metric_filter" {
  source ="../../terraform-modules/aws/cloudwatch/metric-filter"
  log_group_name = module.cloudwatch_log_group.cloudwatch_log_group_name
  VPCFlowLogs_log_group_name = module.vpc_flowlog.vpc_flowloggroup_name
  #log_group_name = var.log_group_name
}

module "cloudwatch_log_group" {
  source = "../../terraform-modules/aws/cloudwatch/log-group"
}

module "vpc_flowlog" {
  source = "../../terraform-modules/aws/platform-services/vpc_flowlog"
  vpc_id = data.aws_vpc.current.id
}

module "sns_topic" {
  source = "../../terraform-modules/aws/sns/sns_topics"
  sns_topic_name = var.sns_topic_name
  sns_topic_policy = data.aws_iam_policy_document.sns_access_policy.json
}

module "sqs_queue" {
  source = "../../terraform-modules/aws/sqs"
  queue_name = var.queue_name
  sqs_access_policy = data.aws_iam_policy_document.sqs_access_policy.json
}

module "sns_topic_subscription"{
  source = "../../terraform-modules/aws/sns/sns_topic_subscription"
  sns_topic_subscription_topic_arn = module.sns_topic.sns_topic_arn
  sns_topic_subscription_protocol = "sqs"
  sns_topic_subscription_endpoint = module.sqs_queue.base_queue_arn
}

