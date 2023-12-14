terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6.0"
    }

  }

  # backend "s3" {
  #   bucket         = "ue1innodsos3iac001"
  #   dynamodb_table = "ue1innodsodbdiac001"
  #   key            = "terraform-demo.tfstate"
  #   region         = "us-west-2"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-west-2"
}