# ----------------------------
# TERRAFORM S3 BACKEND
# ----------------------------

terraform {
  backend "s3" {
    bucket       = "aws-s3-oidc-lambda02072025"
    key          = "serverless/aws_health_notifier.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
