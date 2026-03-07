# ---------------------------------------------------------------------------------------------------------------------
# PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "github_token" {
  description = "GitHub Personal Access Token with repo scope."
  type        = string
  default     = ""
}
