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
  default     = "AWS EventBridge rule for AWS Health."
}