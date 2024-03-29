terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # lock version of the AWS provider
      version = "= 3.70"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "= 2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.7.1"
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
data "aws_availability_zones" "az" {
  state = "available"
}

#data "external" "tfid" {
#  program = ["bash", "get-tfid.sh"]
#}

resource "aws_dynamodb_table" "terraform_lock" {
  # switch var
  name         = format("tf_lock_%s_%s", random_id.id1.hex, lower(basename(path.cwd)))
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.ekskey.arn
  }
}







