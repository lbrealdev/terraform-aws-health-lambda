#----------------------------------
# AWS EventBridge variables
#----------------------------------

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
# AWS Lambda variables (Function + CloudWatch Log Group + IAM Role)
#----------------------------------

# Lambda

variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Memory size for Lambda function in MB."
  type        = number
  default     = null
}

variable "timeout" {
  description = "Timeout for Lambda function in seconds."
  type        = number
  default     = 30
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
  default     = null
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = null
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
  default     = null
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
  default     = null
}

variable "lambda_zip_path" {
  description = "Path to the Lambda zip file."
  type        = string
  default     = null
}

# CloudWatch

variable "logging_config" {
  description = "Logging configuration for Lambda function."
  type = object({
    log_format            = optional(string, "JSON")
    application_log_level = optional(string, "INFO")
    system_log_level      = optional(string, "INFO")
  })
  default = {}
}

# IAM

variable "iam_role_name" {
  description = "Name of the IAM role for the Lambda function."
  type        = string
  default     = "lambda-health-iam-role"
}

variable "iam_policy_name" {
  description = "Name of the IAM policy for the Lambda function."
  type        = string
  default     = "lambda-health-iam-policy"
}

variable "iam_policy_description" {
  description = "Description of the IAM policy for the Lambda function."
  type        = string
  default     = "AWS Health notifier lambda CloudWatch policy"
}