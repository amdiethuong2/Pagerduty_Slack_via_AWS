terraform {
  backend "s3" {
    bucket = "duy-tsaws-state-bucket"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}
