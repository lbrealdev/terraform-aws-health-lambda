provider "aws" {
  region = "eu-central-1"
}

module "aws-health-notifier" {
  source = "./modules/aws-health-notifier"

  function_name   = "health-notifier"
  memory_size     = 128
  runtime         = "python3.12"
  handler         = "handler.lambda_handler"
  lambda_zip_path = "../lambda.zip"

  # GitHub configuration
  github_token = var.github_token
  github_owner = "lbrealdev"
  github_repo  = "aws-health-notifications"
}
