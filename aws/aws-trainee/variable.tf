variable "AWS_REGION" {
  type = string
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

###CloudWatchAlarms##

variable "cloudwatchalerts_sns_topic_name" {
  type    = string
}

variable "cloudwatchalerts_sqs_name" {
  type = string
}

###VPC_flow_logs####

variable "flowlogrole_name" {
  type    = string
  default = ""
}

variable "flowlogrole_policy_name" {
  type    = string
  default = ""
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