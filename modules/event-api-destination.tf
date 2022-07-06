resource "aws_cloudwatch_event_api_destination" "slack_hook_api" {
  name                             = var.slack_api_destination
  description                      = "An API Destination to slack"
  invocation_endpoint              = "https://hooks.slack.com/services/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"
  http_method                      = "POST"
  invocation_rate_limit_per_second = 20
  connection_arn                   = aws_cloudwatch_event_connection.slack_API_connection.arn
}

resource "aws_cloudwatch_event_api_destination" "pagerduty_api" {
  name                             = var.pagerduty_api_destination
  description                      = "An API Destination to pagerduty"
  invocation_endpoint              = "https://events.pagerduty.com/v2/enqueue"
  http_method                      = "POST"
  invocation_rate_limit_per_second = 20
  connection_arn                   = aws_cloudwatch_event_connection.pagerduty_API_connection.arn
}

output "slack_hook_API_destination_endpoint" {
  value = aws_cloudwatch_event_api_destination.slack_hook_api.invocation_endpoint
}

output "pagerduty_hook_API_destination_endpoint" {
  value = aws_cloudwatch_event_api_destination.pagerduty_api.invocation_endpoint
}
