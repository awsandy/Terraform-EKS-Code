terraform {
backend "s3" {
bucket="tf-eks-state-46f56ed187e3c8ea"
key = "terraform/terraform_state_child.tfstate"
region = "eu-west-1"
dynamodb_table = "terraform_locks_child"
encrypt = true
}
}
