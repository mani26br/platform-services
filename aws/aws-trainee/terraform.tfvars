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
aws_ssm_instanceIds = [
    {
      key = "InstanceIds"
      values = "*"
    },
  ]

aws_ssm_tags = [
    {
      key = "tag:OS"
      values = "Windows"
    },
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
  ]

  aws_ssm_resource_group = [
    {
      key = "resource-groups:Name"
      values= "test"
    }
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
						"log_group_name": "/aws/ssm/265129476828/Prod/ec2/syslogs",
						"log_stream_name": "{instance_id}",
						"retention_in_days": -1
					}
				]
			}
		}
	}
}
EOF

window_cw_agent_config = <<EOF
  {
  "logs": {
    "logs_collected": {
      "windows_events": {
        "collect_list": [
          {
            "event_format": "xml",
            "event_levels": [
                    "VERBOSE",
                    "INFORMATION",
                    "WARNING",
                    "ERROR",
                    "CRITICAL"
            ],
            "event_name": "System",
            "log_group_name": "/aws/ssm/265129476828/Prod/ec2/syslogs",
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
  action = "configure (append)"
	mode = "ec2"
	optionalConfigurationSource = "ssm"
	optionalConfigurationLocation = "/cpe/cw-agent/infra/config"
	optionalRestart = "yes"
}
configure_window_cw_agent_parameters = {
  action = "configure (append)"
	mode = "ec2"
	optionalConfigurationSource = "ssm"
	optionalConfigurationLocation = "/cpe/cw-agent/infra/config-window"
	optionalRestart = "yes"
}
status_cw_agent_parameters = {
  action = "status"
	mode = "ec2"
	optionalRestart = "no"
}
aws_ssm_bucket_name = "aws-trainee-ssm-s3-bucket"
aws_ssm_sgc_bucket_name = "aws-trainee-snow-sgc-data"

###Security Groups###
sg_ingress_http = {
  SG = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["156.40.252.0/25", "156.40.252.128/26", "156.40.252.192/27", "156.40.252.240/32", "156.40.252.224/28"]
    description = "NIH wireless"
  }

  SG2 = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["128.231.234.0/27"]
    description = "NIH VPN"
  }
  
  SG3 = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["128.231.234.32/32"]
    description = "NCATS Sci VPN"
  }

  SG4 = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["128.231.234.64/27"]
    description = "NCATS VPN"
  }
}

sg_ingress_https = {
  SG = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["156.40.252.0/25", "156.40.252.128/26", "156.40.252.192/27", "156.40.252.240/32", "156.40.252.224/28"]
    description = "NIH wireless"
  }

  SG2 = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["128.231.234.0/27"]
    description = "NIH VPN"
  }
  
  SG3 = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["128.231.234.32/32"]
    description = "NCATS Sci VPN"
  }

  SG4 = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["128.231.234.64/27"]
    description = "NCATS VPN"
  }
}

sg_egress = {
  SG = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###Launch_Template###
launch_template_image_id = "ami-01a07412dc3259433"
launch_template_vpc_security_group_ids = ["sg-09715acd2b4c22c47"]
launch_template_ssh_key = "ec2"