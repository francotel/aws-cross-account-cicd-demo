terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6.0"
    }

  }

  backend "s3" {
    bucket = "across-account-terraform-state-backend"
    # dynamodb_table = "terraform_state"
    key     = "cross-role-tf.tfstate"
    region  = "us-west-2"
    encrypt = true
  }

}

provider "aws" {
  region = "us-west-2"
  # assume_role {
  #   role_arn = "arn:aws:iam::087657543526:role/ExternalAccountRole"
  # }
}