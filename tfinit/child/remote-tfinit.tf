data terraform_remote_state "tfinit" {

backend = "s3"
config = {
bucket=format("tf-eks-state-%s",data.external.tfid.result.Name)
region = data.aws_region.current.name
key = "terraform/tf_state_tfinit.tfstate"
}
}