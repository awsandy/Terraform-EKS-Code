data "aws_subnet" "i1" {
  subnet_id = data.aws_subnet_ids.private.ids[0]
}

data "aws_subnet" "i2" {
  subnet_id = data.aws_subnet_ids.private.ids[1]

}

data "aws_subnet" "i3" {
  subnet_id = data.aws_subnet_ids.private.ids[2]
  
}