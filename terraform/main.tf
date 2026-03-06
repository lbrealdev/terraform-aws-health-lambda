provider "aws" {
  region = "eu-central-1"
}

resource "aws_cloudwatch_event_rule" "health_notifier" {
  name = var.eventbridge_rule_name
  description = var.eventbridge_rule_description

  event_pattern = jsonencode({

  })
}
