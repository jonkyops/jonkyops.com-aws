provider "aws" {
  region = "us-east-1"
}

provider "archive" {}

# state storage
terraform {
  backend "s3" {}
}
