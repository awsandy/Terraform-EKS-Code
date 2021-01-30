terraform {
backend "s3" {
bucket="tf-eks-state-a9cb983fb5734f5f"
key = "terraform/tf_state_self.tfstate"
region = "eu-west-1"
dynamodb_table = "tf_lock_a9cb983fb5734f5f_self"
encrypt = true
}
}
