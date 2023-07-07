variable "AWS_REGION" {
  default = "us-east-1"
}

variable "platform_service_default_group_name" {
  type    = string
  default = ""
}

variable "guardduty_event_name" {
  type    = string
  default = ""
}

variable "guardduty_sns_topic_name" {
  type    = string
  default = ""
}