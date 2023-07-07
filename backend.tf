terraform {
  backend "s3" {
    bucket  = "bucket-nae"
    key     = "pathto/statefile"
    region  = "us-east-1"
    access_key = "AWS_ACCESS_KEY"
    secret_key = "AWS_SECRET_ACCESS_KEY"
    role_arn = "arn:aws:iam::#:role/aws-role"
    session_name = "terraform"
  }
}