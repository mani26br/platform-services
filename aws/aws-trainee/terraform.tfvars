AWS_REGION = "us-east-1"
common_tags = {     
      "project"       = "ITRB"
      "environment"   = "TRAINEE"
      "Access-team"   = "NCATS-DevOps"
}

###CloudWatch alerts###
metric_namespace = "CloudWatchAlarms"
cloudtrail_loggroup_name = "axleinfo-int-cloudtrail-logs-853931821519-a7aa581f"
cloudwatchalerts_sns_topic_name = "aws-trainee-cloudwatchalerts-notifcations"
cloudwatchalerts_sqs_name = "aws-trainee-cloudwatchalerts-queue"

###vpc flow logs###
flowlogrole_name = "aws-trainee-vpc-flow-log-role"
flowlogrole_policy_name = "aws-trainee-vpc-flow-log-policy"

###AWS_System_Manager###
cw_agent_confg = "test"
install_cw_agent_parameters = {
  action = "Install"
  name = "AmazonCloudWatchAgent"
}
configure_cw_agent_parameters = {
  action = "configure"
	mode = "ec2"
	optionalConfigurationSource = "ssm"
	optionalConfigurationLocation = "/cw-agent/config"
	optionalRestart = "yes"
}

###Security Groups###
sg_name = "NIH-SG"
sg_description = "Security groups for ABAC within NIH CIDR block"
sg_ingress = {
      SG = {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["15.0.0.0/24", "10.0.0.0/24"]
    }

    SG2 = {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["15.0.0.0/24"]
    }
}

sg_egress = {
    SG = {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["15.0.0.0/24"]
    }
  }