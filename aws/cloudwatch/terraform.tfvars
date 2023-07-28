AWS_REGION = "us-east-1"
log_group_name = "aws-cloudtrail-logs-594244466763-f66085b0"
#axle trainee account
#log_group_name = "axleinfo-int-cloudtrail-logs-853931821519-a7aa581f"
alarm_actions = ["arn:aws:sns:us-east-1:594244466763:Default_CloudWatch_Alarms_Topic"]
#axle trainee account
#alarm_actions = ["arn:aws:sns:us-east-1:853931821519:Topic-DevSecOps"]
vpc_id = "vpc-071c9a3420aa5120a"