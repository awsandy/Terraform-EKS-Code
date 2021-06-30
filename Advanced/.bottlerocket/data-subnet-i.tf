data "aws_subnet" "i1" {
  id = data.aws_subnet_ids.private.ids[0]
}

data "aws_subnet" "i2" {
  id = data.aws_subnet_ids.private.ids[1]

}

data "aws_subnet" "i3" {
  id = data.terraform_remote_state.net.outputs.isolated_subnet_id[2]
  
}