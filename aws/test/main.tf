data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

output "id"{
  value = data.aws_caller_identity.current.arn
}

output "region"{
  value = data.aws_region.current.id
}

resource "aws_route53_resolver_query_log_config" "example" {
  name            = "CW-query-logs"
  destination_arn = "arn:aws:logs:us-east-1:594244466763:log-group:/aws/route53/cw-log-query-logs"

  tags = {
    Environment = "Prod"
  }
}

