data "aws_subnet" "p1" {
  id = data.terraform_remote_state.net.outputs.private_subnet_id[0]

}

data "aws_subnet" "p2" {
  id = data.terraform_remote_state.net.outputs.private_subnet_id[1]

}


data "aws_subnet" "p3" {
  id = data.terraform_remote_state.net.outputs.private_subnet_id[2]

}