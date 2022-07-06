#create an event bus named api_bus
resource "aws_cloudwatch_event_bus" "api_bus" {
  name = var.event_bus
}

#discover the event bus
resource "aws_schemas_discoverer" "dicover_event_bus" {
  source_arn  = aws_cloudwatch_event_bus.api_bus.arn
  description = "Auto discover event schemas"
}


# create a policy that allows event bus to write to cloudwatch
data "aws_iam_policy_document" "event_bus" {
  statement {
    sid = "allow_account_to_put_events"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root", ]
    }
    actions   = ["events:PutEvents", ]
    resources = ["arn:aws:events:${var.region}:${var.account_id}:event-bus/${var.event_bus}", ]
  }
  statement {
    sid = "allow_account_to_manage_rules_they_created"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root", ]
    }
    actions   = ["events:PutRule", "events:PutTargets", "events:DeleteRule", "events:RemoveTargets", "events:DisableRule", "events:EnableRule", "events:TagResource", "events:UntagResource", "events:DescribeRule", "events:ListTargetsByRule", "events:ListTagsForResource", ]
    resources = ["arn:aws:events:${var.region}:${var.account_id}:rule/${var.event_bus}", ]
    condition {
      test     = "StringEqualsIfExists"
      variable = "events:creatorAccount"
      values   = ["${var.account_id}", ]
    }
  }
}
resource "aws_cloudwatch_event_bus_policy" "event_bus_permission" {
  policy         = data.aws_iam_policy_document.event_bus.json
  event_bus_name = aws_cloudwatch_event_bus.api_bus.name
}



output "event_bus_name" {
  value = aws_cloudwatch_event_bus.api_bus.name
}
