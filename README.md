# terraform-aws-health-lambda

A Terraform module to deploy a serverless architecture for sending AWS Health notifications to GitHub Issues.

## Architecture

```
┌─────────────────┐     ┌────────────────┐     ┌──────────────┐     ┌────────────────┐
│   AWS Health    │────▶│  EventBridge   │────▶│    Lambda    │────▶│   GitHub API   │
│   (Service)     │     │     Rule       │     │   (Rust)     │     │    (Issues)    │
└─────────────────┘     └────────────────┘     └──────────────┘     └────────────────┘
                                                      │
                                                      ▼
                                            ┌──────────────────┐
                                            │  CloudWatch      │
                                            │  Logs            │
                                            └──────────────────┘
```

## Usage

```hcl
module "health-notifier" {
  source = "./modules/health-notifier"

  github_token = var.github_token
  github_owner = "my-org"
  github_repo  = "my-repo"
}
```

## Requirements

- Terraform >= 1.0
- AWS credentials configured

## Inputs

| Name             | Description                         | Type     | Required |
|------------------|-------------------------------------|----------|----------|
| `github_token`   | GitHub Personal Access Token        | `string` | Yes      |
| `github_owner`   | GitHub owner (organization or user) | `string` | Yes      |
| `github_repo`    | GitHub repository name              | `string` | Yes      |
| `lambda_timeout` | Lambda function timeout (seconds)   | `number` | No       |
| `lambda_memory`  | Lambda function memory (MB)         | `number` | No       |

## Outputs

| Name                   | Description                 |
|------------------------|-----------------------------|
| `lambda_function_name` | Name of the Lambda function |
| `lambda_function_arn`  | ARN of the Lambda function  |
| `eventbridge_rule_arn` | ARN of the EventBridge rule |
