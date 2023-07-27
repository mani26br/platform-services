variable "AWS_REGION" {
  type = string
}

variable "log_group_name" {
    description = "The name of the log group to associate the metric filter with."
    type = string
}

variable "alarm_actions" {
    description = "The name of the log group to associate the metric filter with."
    type = list(string)
}

variable "sns_topic_name" {
  type    = string
}

variable "queue_name" {
  type = string
}
