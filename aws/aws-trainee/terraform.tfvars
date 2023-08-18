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
aws_ssm_tags = [
    # {
    #   key = "tag:tag1Key"
    #   values = "org"
    # },
    # {
    #   key = "tag:tag2Key"
    #   values = "program"
    # },
    # {
    #   key = "tag:tag3Key"
    #   values = "project"
    # },
    # {
    #   key = "tag:tag4Key"
    #   values = "Access-team"
    # },
    {
      key ="InstanceIds"
      values = "*"
    },
  ]

cw_agent_config = <<EOF
  {
	"agent": {
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/syslog", 
						"log_group_name": "/aws/ssm/265129476828/Prod/ec2/syslogs",
						"log_stream_name": "{instance_id}",
						"retention_in_days": -1
					},

          {
						"file_path": "/var/log/audit/audit.log", 
						"log_group_name": "/aws/ssm/265129476828/Prod/ec2/auditlogs",
						"log_stream_name": "{instance_id}",
						"retention_in_days": -1
					},
          
          {
						"file_path": "C:\Windows\system32\winevt\Logs\System.evtx", 
						"log_group_name": "/aws/ssm/265129476828/Prod/ec2/WinSysLogs",
						"log_stream_name": "{instance_id}",
						"retention_in_days": -1
					}
				]
			}
		}
	}
}
EOF

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
ssm_parameter_store_name = "/cw-agent/config"
aws_ssm_bucket_name = "aws-trainee-ssm-s3-bucket"

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