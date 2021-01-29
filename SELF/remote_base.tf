data "external" "tfid" {
  program = ["bash", "get-tfid.sh"]
}

output "Name" {
  value = data.external.tfid.result.Name
}


data terraform_remote_state "self" {
depends_on=[null_resource.backend]
backend = "s3"
config = {
bucket = data.external.tfid.result.Name
region = data.aws_region.current.name
key = "terraform/terraform_state_self.tfstate"
}
}