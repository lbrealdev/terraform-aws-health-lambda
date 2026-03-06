# ---------------------------------------------------------------------------------------------------------------------
# PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "eventbridge_rule_name" {
  description = "Name of the event bridge rule"
  type        = string
  default     = "aws-health-eb-rule"
}

variable "eventbridge_rule_description" {
  description = "The description of the eventbridge rule"
  type        = string
  default     = "EventBridge rule for AWS Health."
}

# AWS Lambda Variables (Function + CloudWatch Log Group + IAM Role)

#----------------------------------
# Lambda variables
#----------------------------------

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
  default     = "health-notifier"
}

# variable "handler" {
#   description = "Function entrypoint in your code."
#   type        = string
#   default     = "main.lambda_handler"
# }
#
# variable "runtime" {
#   description = "Identifier of the function's runtime."
#   type        = string
#   default     = "python3.12"
# }
