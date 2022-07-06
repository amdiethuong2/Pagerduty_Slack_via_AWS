locals {
  routing_key = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["routing_key"]
}

# target is set to slack connection
resource "aws_cloudwatch_event_target" "slack_event_target" {
  rule           = aws_cloudwatch_event_rule.slack_rule.name
  arn            = aws_cloudwatch_event_api_destination.slack_hook_api.arn
  event_bus_name = aws_cloudwatch_event_bus.api_bus.name
  role_arn       = aws_iam_role.slack_event_target.arn
  input_transformer {
    input_paths = {
      text : "$.detail.text"
    }

    input_template = <<EOF
{
	"text":"<text>"
}
		EOF
  }
}

# target is set to pagerdeuty connection
resource "aws_cloudwatch_event_target" "pagerduty_event_target" {
  rule           = aws_cloudwatch_event_rule.pagerduty_rule.name
  arn            = aws_cloudwatch_event_api_destination.pagerduty_api.arn
  event_bus_name = aws_cloudwatch_event_bus.api_bus.name
  role_arn       = aws_iam_role.pagerduty_event_target.arn
  input_transformer {
    input_paths = {
      "company" : "$.detail.company",
      "name" : "$.detail.name"
    }

    input_template = <<EOF
		{
  "payload": {
    "summary": "<name>",
    "severity": "critical",
    "source": "prod-datapipe03.example.com",
    "group": "prod-datapipe",
    "custom_details": {
    	"detail" : "<company>"
	}
  },
  "routing_key": "${local.routing_key}",
  "event_action": "trigger"
}
		EOF
  }
}

