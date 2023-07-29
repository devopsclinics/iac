terraform {
  backend "s3" {
    bucket = "devclinics"
    key    = "starter/terraform.tfstate"
    region = "us-east-1"
  }
}
