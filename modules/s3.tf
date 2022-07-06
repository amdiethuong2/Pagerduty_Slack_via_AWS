# create a bucket ato store email
resource "aws_s3_bucket" "email_bucket" {
  bucket = var.email_bucket
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# set private rule for the email_bucket
resource "aws_s3_bucket_public_access_block" "email_bucket_policy" {
  bucket                  = var.email_bucket
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Adding S3 bucket as a trigger to lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = var.email_bucket
  lambda_function {
    lambda_function_arn = aws_lambda_function.API_trigger.arn
    events = [
      "s3:ObjectCreated:*"
    ]
  }
}

# S3 policy to allow invoking from ses
data "aws_iam_policy_document" "ses" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com", ]
    }
    actions   = ["s3:PutObject", ]
    resources = ["arn:aws:s3:::${var.email_bucket}/*", ]
    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = ["${var.account_id}", ]
    }
  }
}
resource "aws_s3_bucket_policy" "allow_SES_put" {
  bucket = var.email_bucket
  policy = data.aws_iam_policy_document.ses.json
}


# create terraform state bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Set private rules for state bucket
resource "aws_s3_bucket_public_access_block" "state_bucket_policy" {
  bucket                  = var.state_bucket
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

output "s3_name" {
  value = aws_s3_bucket.email_bucket.id
}
