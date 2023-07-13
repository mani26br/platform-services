
# ###MFA###
# module "iam-enforce-mfa-group-policy" {
#   source = "../../terraform-modules/aws/platform-services/mfa_iam_policy/"
# }
# resource "aws_iam_group" "platform-service-default-group" {
#   name = var.platform_service_default_group_name
# }
# resource "aws_iam_group_policy_attachment" "enforce-mfa-group-policy-attachment" {
#   group      = aws_iam_group.platform-service-default-group.name
#   policy_arn = module.iam-enforce-mfa-group-policy.iam_policy_arn
# }
# ###configrules###
# module "aws_configrecorder"{
#   source = "../../terraform-modules/aws/platform-services/configrecorder/"
# }
# module "aws-NIST-800-53-configrules" {
#   source = "../../terraform-modules/aws/platform-services/configrules/"
# }
# ###passwd_policy###
# module "passwd_policy"{
#   source = "../../terraform-modules/aws/platform-services/passwd_policy/"
# }


# ###Guard_Duty###

# ###SNS_Notifications###

# module "sns_guardduty_notificatoons"{
#   source = "../../terraform-modules/aws/sns/sns_topics"
#   sns_topic_name = var.guardduty_sns_topic_name
#   sns_topic_display_name = var.guardduty_sns_topic_name
# }


# module "aws_guard_duty"{
#   source = "../../terraform-modules/aws/platform-services/guard_duty"
#   guarddutyevent_name = var.guardduty_event_name
#   notification_arn = module.sns_guardduty_notificatoons.sns_topic_arn
# }

module "cloudwatch_alarms" {
  source ="../../terraform-modules/aws/cloudwatch/metric-alarm"
  metric_name = var.cloudwatch_alarm_name
}