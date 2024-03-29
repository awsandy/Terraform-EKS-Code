# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc.vpc-vpc-:
resource "aws_vpc" "cluster" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = var.cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
 

  tags = {
    "Name" = format("eks-%s", var.cluster-name)
  }


  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


output "eks-vpc" {
  value = aws_vpc.cluster.id
}

output "eks-cidr" {
  value = aws_vpc.cluster.cidr_block
}

output "vpc_network_id" {
  value = aws_vpc.cluster.id
}
