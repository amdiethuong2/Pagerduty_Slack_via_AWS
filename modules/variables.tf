locals {
  slack_key     = "Authorization"
  pagerduty_key = "PagerDuty Authorization"
}
variable "region" {
  description = "Name of the the AWS region"
  type        = string
  default     = "us-east-1"
}
variable "slack_rule" {
  description = "Name of the event rule to route to slack connection"
  type        = string
  default     = "slack-rule"
}
variable "pagerduty_rule" {
  description = "Name of the event rule to route to pagerduty connection"
  type        = string
  default     = "pagerduty-rule"
}
variable "pagerduty_api_destination" {
  description = "Name of the api destination to pagerduty"
  type        = string
  default     = "pagerduty-api"
}
variable "slack_api_destination" {
  description = "Name of the api destination to slack"
  type        = string
  default     = "slack-hook-api"
}
variable "system_name" {
  description = "Name of the system"
  type        = string
  default     = "Duy-project"
}
variable "account_id" {
  description = "The account id of the user"
  type        = string
  default     = "827567285143"
}
variable "state_bucket" {
  description = "Name of bucket that stores state"
  type        = string
  default     = "duy-tsaws-state-bucket"
}
variable "email_bucket" {
  description = "Name of bucket that stores emails"
  type        = string
  default     = "duy-email-storage"
}
variable "event_bus" {
  description = "Name of the bus that contains api"
  type        = string
  default     = "api_bus"
}
variable "slack_connection" {
  description = "Name of the connection to Slack"
  type        = string
  default     = "slack-API-connection"
}
variable "pagerduty_connection" {
  description = "Name of the connection to PagerDuty"
  type        = string
  default     = "pagerduty-API-connection"
}
variable "ses_receipt_rule" {
  description = "Name of the ses receipt rule"
  type        = string
  default     = "route-to-s3"
}
variable "ses_receipt_rule_set" {
  description = "Name of the ses receipt rule set"
  type        = string
  default     = "cloud-test-flow-rules"
}
