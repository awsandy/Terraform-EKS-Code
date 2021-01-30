terraform {
  required_version = "~> 0.14.3"
  required_providers {
    aws = {
    source = "hashicorp/aws"
    #  Allow any 3.22+  version of the AWS provider
    version = "~> 3.22"
    }
    null = {
    source = "hashicorp/null"
    version = "~> 3.0"
    }
    external = {
    source = "hashicorp/external"
    version = "~> 2.0"
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

resource "aws_dynamodb_table" "terraform_locks" {
 
  #depends_on=[aws_s3_bucket.terraform_state]
  name         = format("terraform_locks_%s",lower(basename(path.cwd)))
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "null_resource" "backend" {
triggers = {
    always_run = timestamp()
}
depends_on = [aws_dynamodb_table.terraform_locks]
provisioner "local-exec" {
    when = create
    command     = <<EOT
            noout=${var.no-output}
            id=${data.terraform_remote_state.self.outputs.tfid}
            p1=${lower(basename(path.cwd))}
            reg=${data.aws_region.current.name}
            
            idfile="backend.tf"

            printf "terraform {\n" > $idfile
            printf "backend \"s3\" {\n" >> $idfile
            printf "bucket=\"tf-eks-state-%s\"\n" $id >> $idfile
            printf "key = \"terraform/terraform_state_%s.tfstate\"\n" $p1 >> $idfile
            printf "region = \"%s\"\n" $reg >> $idfile
            printf "dynamodb_table = \"terraform_locks_%s\"\n" $p1 >> $idfile
            printf "encrypt = "true"\n" >> $idfile
            printf "}\n" >> $idfile
            printf "}\n" >> $idfile

            terraform init -lock=false -force-copy -no-color
            #echo "done"
     EOT
    #command = "./gen-s3.sh"
}
}

data "external" "tfid" {
  program = ["bash", "get-tfid.sh"]
}

output "Name" {
  value = data.external.tfid.result.Name
}


data terraform_remote_state "self" {

backend = "s3"
config = {
bucket = data.external.tfid.result.Name
region = data.aws_region.current.name
key = "terraform/terraform_state_self.tfstate"
}
}

