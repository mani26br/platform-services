data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpc" "current" {
  tags = {
    Department = "DevSecOps Associate"
    Name = "DevSecOps-vpc"
  }
}

data "aws_iam_policy_document" "sqs_access_policy" {
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

    resources = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.queue_name}"]
    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"

      values = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}",
      ]
    }
  }
}

data "aws_iam_policy_document" "sns_access_policy" {
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

    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}"]

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
    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${var.sns_topic_name}"]
  }


}
