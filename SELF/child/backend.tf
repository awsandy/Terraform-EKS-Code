terraform {
backend "s3" {
bucket="tf-eks-state-45fe452a933df254"
key = "terraform/terraform_state_child.tfstate"
region = "eu-west-1"
dynamodb_table = "tf_lock_45fe452a933df254_child"
encrypt = true
}
}
