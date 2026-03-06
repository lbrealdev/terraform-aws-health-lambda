# ---------------------------------------------------------------------------------------------------------------------
# PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "event_rule_name" {
  description = "Name of the event bridge rule"
  type        = string
  default     = "aws-health-eb-rule"
}

variable "event_rule_description" {
  description = "Description of the EventBridge rule."
  type        = string
  default     = "EventBridge rule for AWS Health events."
}

variable "event_target_id" {
  description = "ID of the EventBridge target."
  type        = string
  default     = "lambda-target"
}

#----------------------------------
# Lambda variables
# AWS Lambda Variables (Function + CloudWatch Log Group + IAM Role)
#----------------------------------

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
  default     = "health-notifier"
}

variable "memory_size" {
  description = "Memory size for Lambda function in MB."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout for Lambda function in seconds."
  type        = number
  default     = 30
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = "handler.lambda_handler"
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "github_token" {
  description = "GitHub Personal Access Token."
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub owner (organization or user)."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda zip file."
  type        = string
  default     = "../lambda.zip"
}
