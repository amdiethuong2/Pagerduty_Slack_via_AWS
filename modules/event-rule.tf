# rule to route through slack connection
resource "aws_cloudwatch_event_rule" "slack_rule" {
  # event rule of the api_bus

  name = var.slack_rule

  event_bus_name = aws_cloudwatch_event_bus.api_bus.name

  description = "Rule that route the event to slack API"

  event_pattern = file("${path.module}/event_json/slack-event-pattern.json")
}

# rule to route through pagerduty connection
resource "aws_cloudwatch_event_rule" "pagerduty_rule" {
  # event rule of the api_bus

  name = var.pagerduty_rule

  event_bus_name = aws_cloudwatch_event_bus.api_bus.name

  description = "Rule that route the event to pagerduty API"

  event_pattern = file("${path.module}/event_json/pagerduty-event-pattern.json")
}

output "slack-rule-name" {
  value = aws_cloudwatch_event_rule.slack_rule.name
}

output "pagerduty-rule-name" {
  value = aws_cloudwatch_event_rule.pagerduty_rule.name
}
