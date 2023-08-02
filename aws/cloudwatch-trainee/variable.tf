variable "AWS_REGION" {
  type = string
}

variable "sns_topic_name" {
  type    = string
}

variable "queue_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "common_tags" {
  type    = map(any)
  default = {}
}