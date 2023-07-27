AWS_REGION = "us-east-1"
#axle trainee account
log_group_name = "axleinfo-int-cloudtrail-logs-853931821519-a7aa581f"
alarm_actions = ["arn:aws:sns:us-east-1:853931821519:Topic-DevSecOps"]

sns_topic_name = "aws-trainee"
queue_name = "aws-trainee"
# sns_topic_subscription_topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}"
# sns_topic_subscription_endpoint = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}"

sns_topic_subscription_topic_arn = "arn:aws:sns:us-east-1:853931821519:aws-trainee"
sns_topic_subscription_endpoint = "arn:aws:sqs:us-east-1:853931821519:aws-trainee"