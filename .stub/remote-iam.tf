data "terraform_remote_state" "iam" {

  backend = "s3"
  config = {
    bucket = format("tf-eks-state-%s", data.external.tfid.result.Name)
    region = data.aws_region.current.name
    key    = "terraform/tf_state_iam.tfstate"
  }
}