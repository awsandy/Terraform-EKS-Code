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
    kubernetes = {
      source = "hashicorp/kubernetes"
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
  name         = format("tf_lock_%s_%s",random_id.id1.hex,lower(basename(path.cwd)))
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
depends_on = [aws_dynamodb_table.terraform_lock]
provisioner "local-exec" {
    when = create
    command     = <<EOT
            
            p1=${lower(basename(path.cwd))}
            reg=${data.aws_region.current.name}
            
            idfile="backend.tf.new"
            tobuild=$(grep 'resource' *.tf | grep '"' | grep  '{' | cut -f2 -d ':' | grep -v '#' |  grep aws_ | wc -l)
            rc=$(terraform state list -no-color | grep 'aws_' | grep -v 'data.' | wc -l )

            echo "Found $rc of $tobuild Terraform resources"
            while [ $rc -lt $tobuild ]; do
              echo "Found $rc of $tobuild Terraform resources ... sleeping 10s"
              sleep 10
              rc=$(terraform state list -no-color | grep 'aws_' | grep -v 'data.' | wc -l )
            done
            sleep 5

            echo "***** Changing state to S3 backend *****"

            id=${random_id.id1.hex}

            printf "terraform {\n" > $idfile
            printf "backend \"s3\" {\n" >> $idfile
            printf "bucket=\"tf-eks-state-%s\"\n" $id >> $idfile
            printf "key = \"terraform/tf_state_%s.tfstate\"\n" $p1 >> $idfile
            printf "region = \"%s\"\n" $reg >> $idfile

            printf "dynamodb_table = \"tf_lock_%s_%s\"\n" $id $p1 >> $idfile
            
            printf "encrypt = "true"\n" >> $idfile
            printf "}\n" >> $idfile
            printf "}\n" >> $idfile

            mv backend.tf.new backend.tf
            terraform init -lock=false -force-copy -no-color

            #rm -f tf-out.txt 
            #echo "done"

     EOT
 
}
}

 

