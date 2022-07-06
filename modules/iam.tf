# create lambda permission to allow lambda readObject from s3
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.system_name}-invoker-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.email_bucket.arn}/*",
    ]
  }
  statement {
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "arn:aws:events:${var.region}:${var.account_id}:event-bus/${var.event_bus}",
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = [
      "*",
    ]
  }
}
resource "aws_iam_policy" "lambda" {
  name        = "${var.system_name}-invoker-lambda"
  description = "Write to eventbridge, read from s3, write to cloudwatch"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}
resource "aws_iam_role_policy_attachment" "Duy-project-lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}


#events assume role for slack and pagerduty event target
data "aws_iam_policy_document" "events_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

# create a slack target role and permission to invoke api destination
resource "aws_iam_role" "slack_event_target" {
  name               = "${var.system_name}-slack-invoker-api-destination"
  assume_role_policy = data.aws_iam_policy_document.events_assume_role.json
}
data "aws_iam_policy_document" "slack_event_target_policy" {
  statement {
    actions = [
      "events:InvokeApiDestination",
    ]
    resources = [
      "arn:aws:events:${var.region}:${var.account_id}:api-destination/${aws_cloudwatch_event_api_destination.slack_hook_api.name}/*",
    ]
  }
}
resource "aws_iam_policy" "slack_event_target" {
  name        = "${var.system_name}-slack-invoker-api-destination"
  description = "Invoke api destination"
  policy      = data.aws_iam_policy_document.slack_event_target_policy.json
}
resource "aws_iam_role_policy_attachment" "Duy-project-slack_event_target_role" {
  role       = aws_iam_role.slack_event_target.name
  policy_arn = aws_iam_policy.slack_event_target.arn
}


# pagerduty target role and permission to invoke pagerduty destination
resource "aws_iam_role" "pagerduty_event_target" {
  name               = "${var.system_name}-pagerduty-invoker-api-destination"
  assume_role_policy = data.aws_iam_policy_document.events_assume_role.json
}
data "aws_iam_policy_document" "pagerduty_event_target_policy" {
  statement {
    actions = [
      "events:InvokeApiDestination",
    ]
    resources = [
      "arn:aws:events:${var.region}:${var.account_id}:api-destination/${aws_cloudwatch_event_api_destination.pagerduty_api.name}/*",
    ]
  }
}
resource "aws_iam_policy" "pagerduty_event_target" {
  name        = "${var.system_name}-pagerduty-invoker-api-destination"
  description = "Invoke api destination"
  policy      = data.aws_iam_policy_document.pagerduty_event_target_policy.json
}

resource "aws_iam_role_policy_attachment" "Duy-project-pagerduty_event_target_role" {
  role       = aws_iam_role.pagerduty_event_target.name
  policy_arn = aws_iam_policy.pagerduty_event_target.arn
}


output "name_of_lambda_iam_role" {
  value = aws_iam_role.lambda.name
}

output "name_of_event_target_iam_role" {
  value = aws_iam_role.slack_event_target.name
}
