data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_cloudwatch_log_groups" "example" {
  log_group_name_prefix = "/aws/vpcflowlogs/"
}

output "test" {
  value = data.aws_cloudwatch_log_groups.example.log_group_names
}