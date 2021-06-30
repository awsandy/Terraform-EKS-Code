data "aws_subnet" "i1" {
  subnet_id = data.terraform_remote_state.net.outputs.isolated_subnet_id[0]
}

data "aws_subnet" "i2" {
  subnet_id = data.terraform_remote_state.net.outputs.isolated_subnet_id[1]

}

data "aws_subnet" "i3" {
  subnet_id = data.terraform_remote_state.net.outputs.isolated_subnet_id[2]
  
}