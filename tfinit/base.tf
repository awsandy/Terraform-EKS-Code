terraform {
  required_version = "~> 0.14.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Allow any 3.22+  version of the AWS provider
      version = "~> 3.22"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.1"
    }

  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.profile
}
provider "null" {}
provider "external" {}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "external" "tfid" {
  program = ["bash", "get-tfid.sh"]
}

resource "aws_dynamodb_table" "terraform_lock" {
  # switch var
  name         = format("tf_lock_%s_%s", random_id.id1.hex, lower(basename(path.cwd)))
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}





