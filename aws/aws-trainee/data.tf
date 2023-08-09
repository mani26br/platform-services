data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpc" "current" {
  tags = {
    Name = var.vpc_name[0] 
  }
}
data "aws_vpcs" "current" {}
# locals {
#   vpc_ids_map = {
#     for idx, vpc_id in data.aws_vpcs.current.ids : var.vpc_name[idx] => vpc_id
#   }
# }

###CWA Policies###

data "aws_iam_policy_document" "cwa_sqs_queue_policy" {
  version = "2012-10-17"
  statement {
    sid = "First"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions = [
      "sqs:SendMessage",
    ]

    resources = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.cloudwatchalerts_sqs_name}"]
    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"

      values = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.cloudwatchalerts_sns_topic_name}",
      ]
    }
  }
}

data "aws_iam_policy_document" "cwa_sns_topic_policy" {
  version = "2008-10-17"
  policy_id = "__default_policy_ID"
  statement {
    sid = "__default_statement_ID"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
    ]

    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.cloudwatchalerts_sns_topic_name}"]

    condition {
      test = "StringEquals"
      variable = "aws:SourceOwner"

      values = ["${data.aws_caller_identity.current.id}",
      ]
    }
  }
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sns:Publish"]
    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.cloudwatchalerts_sns_topic_name}"]
  }


}

####VPC_flow_log_policies###

data "aws_iam_policy_document" "vpc_flow_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "flow_log_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"]
  }
}