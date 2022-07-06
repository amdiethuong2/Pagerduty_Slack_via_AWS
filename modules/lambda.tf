data "template_file" "code" {
  template = file("${path.module}/code/index.py")
  vars = {
    event_bus_name = var.event_bus
    bucket_name    = var.email_bucket
  }
}

data "archive_file" "code" {
  type                    = "zip"
  output_path             = "/tmp/package-index.zip"
  source_content          = data.template_file.code.rendered
  source_content_filename = "index.py"
}

resource "aws_lambda_function" "API_trigger" {
  function_name    = "API-trigger"
  description      = "trigger pagerduty and slack api"
  runtime          = "python3.7"
  role             = aws_iam_role.lambda.arn
  handler          = "index.lambda_handler"
  filename         = data.archive_file.code.output_path
  source_code_hash = data.archive_file.code.output_base64sha256
}

resource "aws_lambda_permission" "lambda_s3_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.API_trigger.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.email_bucket}"
}


output "lambda_name" {
  value       = aws_lambda_function.API_trigger.function_name
  description = "name of lambda"
}
