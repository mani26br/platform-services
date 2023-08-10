data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpcs" "current" {}
data "aws_cloudwatch_log_groups" "example" {
  #log_group_name_prefix = "/aws/vpcflowlogs/"
  log_group_name_prefix = "/aws/eks/"
}

output "test" {
  value = tolist(data.aws_cloudwatch_log_groups.example.log_group_names)[0]
}

output "vpc" {
  value = data.aws_vpcs.current.ids
}