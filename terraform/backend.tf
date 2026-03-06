# ----------------------------
# TERRAFORM S3 BACKEND
# ----------------------------

terraform {
  backend "s3" {
    bucket       = "aws-s3-oidc-lambda02072025"
    key          = "UPDATE"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
