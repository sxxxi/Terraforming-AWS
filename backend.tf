terraform {
  backend "s3" {
    bucket = "l3-bucket"
    key    = "terraform.state"
    region = "us-east-1"
  }
}