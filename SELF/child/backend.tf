terraform {
backend "s3" {
bucket="tf-eks-state-a9cb983fb5734f5f"
key = "terraform/tf_state_child.tfstate"
region = "eu-west-1"
dynamodb_table = "tf_lock_a9cb983fb5734f5f_child"
encrypt = true
}
}
