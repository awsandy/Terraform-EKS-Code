data "aws_subnet_ids" "private" {
    vpc_id = aws_vpc.cluster.id
    tags = {
        "subnet-type"  = "private"
    }
  depends_on = [
    aws_subnet.private
   ]
}

data "aws_subnet_ids" "isolated" {
    vpc_id = aws_vpc.cluster.id
    tags = {
        "subnet-type"  = "isolated"
    }
  depends_on = [
    aws_subnet.isolated
  ]
}




resource "aws_subnet" "isolated" {
  count = var.az_counts
  depends_on                      = [aws_vpc_ipv4_cidr_block_association.vpc-cidr-assoc]
  availability_zone = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(var.cidr_block2, 4, count.index)
  vpc_id = aws_vpc.cluster.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.cluster-name}-isolated-${data.aws_availability_zones.az.names[count.index]}",
    "subnet-type"             = "isolated"   
    # no longer needed
    #"kubernetes.io/cluster/${var.cluster-name}" = "shared",

  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


resource "aws_subnet" "private" {
  count = var.az_counts

  availability_zone = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index)
  vpc_id = aws_vpc.cluster.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.cluster-name}-private-${data.aws_availability_zones.az.names[count.index]}",
    "kubernetes.io/role/internal-elb"           = "1"
    "subnet-type"             = "private"
    # no longer needed
    #"kubernetes.io/cluster/${var.cluster-name}" = "shared",
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


output "private_subnet_id" {
  value          = [for az, subnet in aws_subnet.private: subnet.id]
}
output "isolated_subnet_id" {
  value          = [for az, subnet in aws_subnet.isolated: subnet.id]
}