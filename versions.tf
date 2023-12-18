terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6.0"
    }

  }

  backend "s3" {
    bucket  = "across-account-terraform-state-backend"
    key     = "devops-account/demo-multi-account.tfstate"
    region  = "us-west-2"
    encrypt = true
  }

}

provider "aws" {
  region = "us-east-1"
}