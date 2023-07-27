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
  #"arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}"
  sns_topic_subscription_protocol = "sqs"
  sns_topic_subscription_endpoint = module.sqs_queue.base_queue_arn
  #"arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.queue_name}"
}
