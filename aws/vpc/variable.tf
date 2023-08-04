variable "AWS_REGION" {
  type = string
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

