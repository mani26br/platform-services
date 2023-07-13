variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}

variable "metric_filter_name" {
  type = string
  default = "DeleteAccessKey"
}