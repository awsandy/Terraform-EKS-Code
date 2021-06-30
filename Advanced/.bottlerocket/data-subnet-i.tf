data "aws_subnet" "i1" {
  id = data.terraform_remote_state.net.outputs.isolated_subnet_id[2]
}

data "aws_subnet" "i2" {
  id = data.terraform_remote_state.net.outputs.isolated_subnet_id[2]

}

data "aws_subnet" "i3" {
  id = data.terraform_remote_state.net.outputs.isolated_subnet_id[2]
  
}