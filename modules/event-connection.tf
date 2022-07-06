# create a slack connection
resource "aws_cloudwatch_event_connection" "slack_API_connection" {
  name               = var.slack_connection
  description        = "A connection to slack API"
  authorization_type = "API_KEY"
  auth_parameters {
    api_key {
      key   = local.slack_key
      value = "dummy value"
    }
  }
}

# create a pagerduty connection
resource "aws_cloudwatch_event_connection" "pagerduty_API_connection" {
  name               = var.pagerduty_connection
  description        = "A connection to pagerduty API"
  authorization_type = "API_KEY"
  auth_parameters {
    api_key {
      key   = local.pagerduty_key
      value = "dummy value"
    }
  }
}
