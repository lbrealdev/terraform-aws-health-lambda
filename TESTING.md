# Testing the Lambda Function

## Create Test Event File

```bash
cat > test-event.json << 'EOF'
{"detail": {"eventTypeCode": "AWS_EC2_INSTANCE_METADATA_QUOTA_LIMIT", "service": "EC2", "region": "eu-central-1", "eventTypeCategory": "issue", "arn": "arn:aws:ec2:eu-central-1:123456789012:instance/i-1234567890abcdef0", "startTime": "2026-03-06T10:00:00Z"}}
EOF
```

## Invoke Lambda

```bash
aws lambda invoke \
  --function-name health-notifier \
  --payload file://test-event.json \
  --cli-binary-format raw-in-base64-out \
  response.json
```

## Check the Response

```bash
cat response.json
```

## View CloudWatch Logs

```bash
aws logs tail /aws/lambda/health-notifier --follow
```

Or view specific log stream:

```bash
aws logs describe-log-streams \
  --log-group-name /aws/lambda/health-notifier \
  --order-by LastEventTime \
  --descending \
  --max-items 1
```

Then:

```bash
aws logs get-log-events \
  --log-group-name /aws/lambda/health-notifier \
  --log-stream-name <stream-name>
```
