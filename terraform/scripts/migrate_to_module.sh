#!/bin/bash

# Navigate to terraform directory
cd "$(dirname "$0")"

echo "==> Running terraform init..."
terraform init -upgrade

echo ""
echo "==> Current state resources:"
terraform state list

echo ""
echo "==> Moving resources to module..."

# Get all resources and move them to the module
terraform state list | while read resource; do
    # Extract resource name (everything after the last dot)
    resource_name="${resource##*.}"
    
    # Skip if already in module
    if [[ "$resource" == module.* ]]; then
        echo "Skipping (already in module): $resource"
        continue
    fi
    
    # Map resource names to module paths
    case "$resource" in
        "aws_cloudwatch_log_group.lambda_health_cw_lg")
            new_path="module.aws-health-notifier.aws_cloudwatch_log_group.lambda_health_cw_lg"
            ;;
        "aws_iam_role.lambda_health_iam_role")
            new_path="module.aws-health-notifier.aws_iam_role.lambda_health_iam_role"
            ;;
        "aws_iam_policy.lambda_health_iam_policy")
            new_path="module.aws-health-notifier.aws_iam_policy.lambda_health_iam_policy"
            ;;
        "aws_iam_role_policy_attachment.lambda_health_iam_attachment")
            new_path="module.aws-health-notifier.aws_iam_role_policy_attachment.lambda_health_iam_attachment"
            ;;
        "aws_lambda_function.lambda_health")
            new_path="module.aws-health-notifier.aws_lambda_function.lambda_health"
            ;;
        "aws_lambda_permission.allow_eventbridge")
            new_path="module.aws-health-notifier.aws_lambda_permission.allow_eventbridge"
            ;;
        "aws_cloudwatch_event_rule.health_notifier_event_rule")
            new_path="module.aws-health-notifier.aws_cloudwatch_event_rule.health_notifier_event_rule"
            ;;
        "aws_cloudwatch_event_target.health_notifier_event_target")
            new_path="module.aws-health-notifier.aws_cloudwatch_event_target.health_notifier_event_target"
            ;;
        *)
            echo "Unknown resource: $resource"
            continue
            ;;
    esac
    
    echo "Moving: $resource -> $new_path"
    terraform state mv "$resource" "$new_path"
done

echo ""
echo "==> Final state:"
terraform state list
