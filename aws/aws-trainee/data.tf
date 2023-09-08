data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpcs" "current" {}
# locals {
#   vpc_ids_map = {
#     for idx, vpc_id in data.aws_vpcs.current.ids : var.vpc_name[idx] => vpc_id
#   }
# }
data "aws_cloudwatch_log_groups" "ssm" {
  log_group_name_prefix = "/aws/ssm/"
}

data "aws_cloudwatch_log_groups" "vpcflowlogs" {
  log_group_name_prefix = "/aws/vpcflowlogs/"
}


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

###AWS_System_Manager_S3_Bucket_Policy###
data "aws_iam_policy_document" "aws_ssm_s3_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
 
    resources = ["arn:aws:s3:::${var.aws_ssm_bucket_name}/*",]
}
}

###AWS_System_Manager_SGC_S3_Bucket_Policy###
data "aws_iam_policy_document" "aws_ssm_sgc_s3_policy" {
  version = "2012-10-17"
  statement {
    sid = "AllowAccesstoS3Bucket"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
 
    resources = ["arn:aws:s3:::${var.aws_ssm_sgc_bucket_name}", "arn:aws:s3:::${var.aws_ssm_sgc_bucket_name}/*"]
  }
  # statement {
  #   effect = "Deny"
  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }

  #   actions = [
  #     "s3:GetObject",
  #     "s3:PutObject",
  #     "s3:PutObjectAcl"
  #   ]
 
  #   resources = ["arn:aws:s3:::${var.aws_ssm_sgc_bucket_name}/*"]
  # }
}


###AWS_System_Manager_ec2_policy###
data "aws_iam_policy_document" "aws_ssm_ec2_policy" {

  statement {
    sid = "PublishSyslogsToCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/${data.aws_caller_identity.current.account_id}/${var.common_tags["environment"]}/ec2/syslogs:*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/${data.aws_caller_identity.current.account_id}/${var.common_tags["environment"]}/ec2/auditlogs:*"
    ]
  }
  statement {
    sid = "PublishSSMResultsToS3"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.aws_ssm_bucket_name}/*",
      "arn:aws:s3:::${var.aws_ssm_sgc_bucket_name}/*"
    ]
  }
}

###Security_Group_ABAC_Policy###

data "aws_iam_policy_document" "sg_abac_policy" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"

    actions = [
      "ec2:DescribeSecurityGroupRules",
			"ec2:DescribeSecurityGroups"
    ]
 
    resources = ["*"]
    condition {
      test = "StringEquals"
      variable = "aws:PrincipalTag/Access-team"

      values = [var.common_tags["Access-team"]
      ]
    }
    condition {
      test = "StringEquals"
      variable = "ec2:ResourceTag/environment"

      values = [var.common_tags["environment"]
      ]
    }
  }
}

###Destination_S3_policy###

data "aws_iam_policy_document" "destination_s3_policy" {
  version = "2008-10-17"
  statement {
    sid = "AllowReplication"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.source_account}:root"]
    }

    actions = [
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning",
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ObjectOwnerOverrideToBucketOwner",
    ]
 
    resources = ["arn:aws:s3:::aws-ci-tfstate-s3-backup", 
                "arn:aws:s3:::aws-ci-tfstate-s3-backup/*"] 
}

statement {
    sid = "AllowRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.source_account}:role/${var.splunk_connection_role_name}", "arn:aws:iam::${var.source_account}:root"]
    }

    actions = [
        "s3:List*",
        "s3:Get*"
    ]
 
    resources = ["arn:aws:s3:::aws-ci-tfstate-s3-backup", 
                "arn:aws:s3:::aws-ci-tfstate-s3-backup/*"]
}
}

###Destination_KMS_policy###
data "aws_iam_policy_document" "destination_kms_policy" {
  version = "2012-10-17"
  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.splunk_connection_role_name}", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
        "kms:*",
    ]
 
    resources = ["*"]
}

  statement {
    sid = "Enable cross account encrypt access for S3 Cross Region Replication"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${var.source_account}"]
    }

    actions = [
        "kms:Encrypt",
    ]
 
    resources = ["*"]
}
}
