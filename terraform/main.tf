provider "aws" {
  region = "eu-central-1"
}


#####################################
# AWS EventBridge Rule
#####################################

resource "aws_cloudwatch_event_rule" "health_notifier" {
  name        = var.eventbridge_rule_name
  description = var.eventbridge_rule_description

  event_pattern = jsonencode({
    "source" : ["aws.health"]
  })
}

#####################################
# AWS Lambda Function resouces
#####################################

resource "aws_cloudwatch_log_group" "lambda_health_cw_lg" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7

  tags = {
    Environment = "dev"
    Application = var.function_name
  }
}

resource "aws_iam_role" "lambda_health_iam_role" {
  name = "lambda-health-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_health_iam_policy" {
  name        = "lambda-health-iam-policy"
  path        = "/"
  description = "AWS Health notifier lambda CloudWatch policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.lambda_health_cw_lg.arn}:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.lambda_health_iam_role.name
  policy_arn = aws_iam_policy.lambda_health_iam_policy.arn
}

# resource "aws_lambda_function" "lambda_health" {
#   function_name = var.function_name
#   role          = aws_iam_role.this.arn
#   memory_size   = var.memory_size
#   publish       = var.publish
#   timeout       = var.timeout
#
#   handler = var.handler
#   runtime = var.runtime
#
#   s3_bucket         = aws_s3_object.this.bucket
#   s3_key            = aws_s3_object.this.key
#   s3_object_version = aws_s3_object.this.version_id
#
#   logging_config {
#     log_group             = aws_cloudwatch_log_group.this.name
#     log_format            = "JSON"
#     application_log_level = "INFO"
#     system_log_level      = "INFO"
#   }
#
#   environment {
#     variables = {
#       ETHERSCAN_API_KEY = var.etherscan_api_key
#     }
#   }
#
#   depends_on = [
#     aws_cloudwatch_log_group.this,
#     aws_iam_role.this
#   ]
# }