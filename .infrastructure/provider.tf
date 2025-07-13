# terraform {
#   required_version = "~> 1.1"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# provider "aws" {
#   profile = "default"
#   region  = "eu-west-1"
# }

terraform {
  backend "s3" {
    bucket = "ew-1-tfstate"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    # dynamodb_table = "terraform-lock"
  }
}