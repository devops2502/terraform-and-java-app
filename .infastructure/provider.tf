# Terraform block
# terraform {
#   required_version = "~> 1.1"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# Provider block
# provider "aws" {
#   profile = "default"
#   region  = "eu-west-1"
# }
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}