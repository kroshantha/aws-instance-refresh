terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }
  }

  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/53938354/terraform/state/$TF_STATE_NAME"
    lock_address   = "https://gitlab.com/api/v4/projects/53938354/terraform/state/$TF_STATE_NAME/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/53938354/terraform/state/$TF_STATE_NAME/lock"
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
provider "awscc" {
  region = "ap-southeast-1"
}
