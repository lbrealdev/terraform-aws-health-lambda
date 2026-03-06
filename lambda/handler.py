import os
import json
import logging
import urllib.request
import urllib.error
from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")

    try:
        detail = event.get("detail", {})

        event_type = detail.get("eventTypeCode", "Unknown")
        service = detail.get("service", "Unknown")
        region = detail.get("region", "Global")
        arn = detail.get("arn", "")

        start_time = detail.get("startTime", "")
        if start_time:
            try:
                dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
                start_time = dt.strftime("%Y-%m-%d %H:%M:%S UTC")
            except Exception:
                pass

        category = detail.get("eventTypeCategory", "issue")

        title = f"[AWS Health] {service} - {event_type} in {region}"

        body = f"""## AWS Health Notification

**Service:** {service}
**Region:** {region}
**Event Type:** {event_type}
**Category:** {category}
**Time:** {start_time}
**ARN:** `{arn}`

### Event Details
```
{json.dumps(detail, indent=2)}
```

---
*Created by AWS Health Lambda*
"""

        create_github_issue(title, body)

        return {"statusCode": 200, "body": "Issue created successfully"}

    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        return {"statusCode": 500, "body": f"Error: {str(e)}"}


def create_github_issue(title, body):
    github_token = os.environ.get("GITHUB_TOKEN")
    github_owner = os.environ.get("GITHUB_OWNER")
    github_repo = os.environ.get("GITHUB_REPO")

    if not all([github_token, github_owner, github_repo]):
        raise ValueError(
            "Missing required environment variables: GITHUB_TOKEN, GITHUB_OWNER, GITHUB_REPO"
        )

    url = f"https://api.github.com/repos/{github_owner}/{github_repo}/issues"

    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json",
        "Content-Type": "application/json",
    }

    data = json.dumps(
        {"title": title, "body": body, "labels": ["aws-health", "automated"]}
    ).encode("utf-8")

    request = urllib.request.Request(url, data=data, headers=headers, method="POST")

    try:
        with urllib.request.urlopen(request) as response:
            response_body = response.read().decode("utf-8")
            logger.info(f"GitHub issue created: {response_body}")
            return json.loads(response_body)
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        logger.error(f"GitHub API error: {e.code} - {error_body}")
        raise Exception(f"GitHub API error: {e.code} - {error_body}")
