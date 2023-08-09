data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_vpc" "current" {
  tags = {
    Department = "DevSecOps Associate"
    Name = "DevSecOps-vpc"
  }
}

resource "aws_route53_resolver_query_log_config" "example" {
  name            = "CW-query-logs"
  destination_arn = "arn:aws:logs:us-east-1:594244466763:log-group:/aws/route53/cw-log-query-logs"

  tags = {
    Environment = "Prod"
  }
}

data "aws_route53_zone" "all_zones" {
  name = "axle-interns.com"
}

data "aws_route53_zone" "all_zones2" {
  name = "ci.intern.aws.labshare.org"
}

