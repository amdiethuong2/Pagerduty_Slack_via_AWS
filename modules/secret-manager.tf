data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:duy-secret-T1mtxl"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}
