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

locals {
  CloudWatchMetrics = {
    "VPCFlowLogs" = "[version, account_id, interface_id, src_ip, dest_ip, src_port, dest_port=22, protocol, pkt_count, byte_count, start_time, end_time, action=\"ACCEPT\",status]", 
    "RootAccountUsage" = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"
  }
}

output "metrics" {
  value = local.CloudWatchMetrics
}