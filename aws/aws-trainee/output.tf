# output "test" {
#     value = data.aws_vpcs.current
# }

# locals {
#   vpc_flowlog_instances = {
#     for vpc_id in data.aws_vpcs.current.ids :
#     vpc_id => module.vpc_flowlog[vpc_id]
#   }
# }

# output "vpc_flowlog_instances" {
#   value = local.vpc_flowlog_instances
# }

# output "vpc_flow" {
#   value = local.vpc_flowlog_instances["vpc-09e3a6b6a5f9f30ad"].vpc_flowloggroup_name
# }