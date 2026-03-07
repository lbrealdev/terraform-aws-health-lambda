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
  name = var.iam_role_name

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
  name        = var.iam_policy_name
  description = var.iam_policy_description
  path        = "/"

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

resource "aws_iam_role_policy_attachment" "lambda_health_iam_attachment" {
  role       = aws_iam_role.lambda_health_iam_role.name
  policy_arn = aws_iam_policy.lambda_health_iam_policy.arn
}

resource "aws_lambda_function" "lambda_health" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_health_iam_role.arn
  memory_size   = var.memory_size
  publish       = var.publish
  timeout       = var.timeout

  runtime = var.runtime
  handler = var.handler

  filename = var.lambda_zip_path

  environment {
    variables = {
      GITHUB_TOKEN = var.github_token
      GITHUB_OWNER = var.github_owner
      GITHUB_REPO  = var.github_repo
    }
  }

  logging_config {
    log_group             = aws_cloudwatch_log_group.lambda_health_cw_lg.name
    log_format            = var.logging_config.log_format
    application_log_level = var.logging_config.application_log_level
    system_log_level      = var.logging_config.system_log_level
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_health_cw_lg,
    aws_iam_role.lambda_health_iam_role
  ]
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_health.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_notifier_event_rule.arn
}

#####################################
# AWS EventBridge Rule
#####################################

resource "aws_cloudwatch_event_rule" "health_notifier_event_rule" {
  name        = var.event_rule_name
  description = var.event_rule_description

  event_pattern = jsonencode({
    "source" : ["aws.health"]
  })
}

resource "aws_cloudwatch_event_target" "health_notifier_event_target" {
  rule      = aws_cloudwatch_event_rule.health_notifier_event_rule.name
  target_id = var.event_target_id
  arn       = aws_lambda_function.lambda_health.arn
}
