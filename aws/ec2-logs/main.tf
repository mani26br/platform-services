module "iam_policy" {
  source = "../../terraform-modules/aws/iam/iam_policy_cloudwatch"
}

module "Systems_Manager" {
  source = "../../terraform-modules/aws/platform-services/aws_ssm/aws_ssm_association"
  instance_id = module.iam_policy.ec2_instance_id
}