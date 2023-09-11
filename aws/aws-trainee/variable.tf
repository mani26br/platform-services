variable "AWS_REGION" {
  type = string
}

variable "common_tags" {
  type    = map(any)
  default = {}
}

###CloudWatchAlarms##

variable "metric_namespace" {
  type = string
}

variable "cloudtrail_loggroup_name" {
  type = string
}

variable "cloudwatchalerts_sns_topic_name" {
  type    = string
}

variable "cloudwatchalerts_sqs_name" {
  type = string
}

locals {
  EC2SysLogsMetrics = {
    "SysLogs" = "ERROR"
  }
}

locals {
  VPCFlowLogsMetrics = {
    "VPCFlowLogs" = "[version, account_id, interface_id, src_ip, dest_ip, src_port, dest_port=22, protocol, pkt_count, byte_count, start_time, end_time, action=\"REJECT\",status]" 
  }
}

locals {
  CloudTrailMetrics = {
    "CloudTrailChange" = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
    "IamCreateAccessKey" = "{($.eventName=CreateAccessKey)}"
    "IamDeleteAccessKey" = "{($.eventName=DeleteAccessKey)}"
    "IamPolicyChanges" = "{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"
    "NetworkACLChanges" = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"
    "NetworkGatewayChanges" = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"
    "RouteTableChanges" = "{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}"
    "S3BucketPolicyChanges" = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
    "SecurityGroupChanges" = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}" 
    "UnauthorizedOperation" = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
    "VPCChanges" = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"
    "KMSKeyDeletion" =  "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"
    "AWSConfigChanges" = "{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"
    "ConsoleLoginFailed" = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"
    "RootAccountUsage" = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"
  }
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

###AWS_Systems_Manager###

variable "aws_ssm_instanceIds" {
  type = list(map(string))
}

variable "aws_ssm_tags" {
  type = list(map(string))
}

variable "aws_ssm_resource_group" {
  type = list(map(string))
}

variable "cw_agent_config" {
  type = string
}

variable "window_cw_agent_config" {
  type = string
}

variable "install_cw_agent_parameters" {
  type = map(string)
}

variable "configure_cw_agent_parameters" {
  type = map(string)
}

variable "configure_window_cw_agent_parameters" {
  type = map(string)
}

variable "status_cw_agent_parameters" {
  type = map(string)
}

variable "aws_ssm_bucket_name" {
  type = string
}

variable "aws_ssm_sgc_bucket_name" {
  type = string
}

###AWS_Maintenance_Window###

locals {
  MaintenanceWindow = {
    "name" = "AmazonCloudWatchAgent" 
    "action" = "Install"
  }
}

 # parameter {
      #   name = "name"
      #   values = ["AmazonCloudWatchAgent"]
      # }
      # parameter {
      #   name = "action"
      #   values = ["Install"]
      # }

##Security_Group###

variable "sg_ingress_http" {
  type = any
}

variable "sg_ingress_https" {
  type = any
}

variable "sg_egress" {
  type = any
}

###Launch_Template###
variable "launch_template_image_id" {
  type = string
}

variable "launch_template_vpc_security_group_ids" {
  type = list(string)
}

variable "launch_template_ssh_key" {
  type = string
}


###
variable "splunk_connection_role_name" {
  type    = string
  default = ""
}

variable "aws_source_account_role" {
  type = string
  default = ""
}