# create rule set
resource "aws_ses_receipt_rule_set" "cloud_test_flow_rules" {
  rule_set_name = var.ses_receipt_rule_set
}
# add rule to rule set
resource "aws_ses_receipt_rule" "route_to_s3" {
  name          = var.ses_receipt_rule
  rule_set_name = aws_ses_receipt_rule_set.cloud_test_flow_rules.rule_set_name
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = var.email_bucket
    position    = 1
  }
}
#activate the rule set
resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.cloud_test_flow_rules.rule_set_name
}
output "name_of_rule" {
  value = aws_ses_receipt_rule_set.cloud_test_flow_rules.rule_set_name
}
