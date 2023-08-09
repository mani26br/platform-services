AWS_REGION = "us-east-1"
common_tags = {     
      "project"       = "ITRB"
      "environment"   = "TRAINEE"
      "Access-team"   = "NCATS-DevOps"
}

###CloudWatch alerts###
cloudtrailalerts_name = [ "CloudTrailChange", "IamCreateAccessKey", "IamDeleteAccessKey", "IamPolicyChanges", "NetworkACLChanges", "NetworkGatewayChanges", "RouteTableChanges", "S3BucketPolicyChanges", "SecurityGroupChanges", "UnauthorizedOperation", "VPCChanges", "KMSKeyDeletion", "AWSConfigChanges", "ConsoleLoginFailed", "RootAccountUsage"]
metric_namespace = "CloudWatchAlarms"
cloudtrail_loggroup_name = "axleinfo-int-cloudtrail-logs-853931821519-a7aa581f"
cloudwatchalerts_sns_topic_name = "aws-trainee-cloudwatchalerts-notifcations"
cloudwatchalerts_sqs_name = "aws-trainee-cloudwatchalerts-queue"

###vpc flow logs###
flowlogrole_name = "aws-trainee-vpc-flow-log-role"
flowlogrole_policy_name = "aws-trainee-vpc-flow-log-policy"

