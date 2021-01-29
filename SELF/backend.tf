terraform {
backend "s3" {
bucket="tf-eks-state-495ccbe833157c70"
key = "terraform/terraform_state_self.tfstate"
region = "eu-west-1"
dynamodb_table = "terraform_locks_self"
encrypt = true
}
}
