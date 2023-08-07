variable "AWS_REGION" {
  type = string
}

variable "cloudwatchalerts_sns_topic_name" {
  type    = string
}

variable "cloudwatchalerts_sqs_name" {
  type = string
}

variable "vpc_name" {
  type = list(string)
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

