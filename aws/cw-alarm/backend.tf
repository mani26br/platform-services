terraform {
  backend "s3" {
    bucket  = "s3-devsecops"
    key     = "cw/terraform.tfstate"
    region  = "us-east-1"
    # access_key = "AWS_ACCESS_KEY"
    # secret_key = "AWS_SECRET_ACCESS_KEY"
    # role_arn = "arn:aws:iam::#:role/aws-role"
    session_name = "terraform"
    profile = "trainee"
  }
}