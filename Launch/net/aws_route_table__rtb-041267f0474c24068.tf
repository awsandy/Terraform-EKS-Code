# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table.rtb-041267f0474c24068:
resource "aws_route_table" "rtb-041267f0474c24068" {
  propagating_vgws = []
  route            = []
  tags = {
    "Name" = "eks-cluster/PrivateRouteTableEUWEST1A"

  }
  vpc_id = aws_vpc.cluster.id
}