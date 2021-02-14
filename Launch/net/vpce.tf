# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-autoscaling:
resource "aws_vpc_endpoint" "vpce-autoscaling" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.autoscaling", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ec2:
resource "aws_vpc_endpoint" "vpce-ec2" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ec2", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-vpce-ec2messages:
resource "aws_vpc_endpoint" "vpce-vpce-ec2messages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ec2messages", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ecrapi:
resource "aws_vpc_endpoint" "vpce-ecrapi" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ecr.api", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ecrdkr:
resource "aws_vpc_endpoint" "vpce-ecrdkr" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ecr.dkr", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ec2:
resource "aws_vpc_endpoint" "vpce-elb" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.elasticloadbalancing", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-logs:
resource "aws_vpc_endpoint" "vpce-logs" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.logs", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-s3:
resource "aws_vpc_endpoint" "vpce-s3" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2008-10-17"
    }
  )
  private_dns_enabled = false
  route_table_ids = [
    aws_route_table.rtb-0102c621469c344cd.id,
    aws_route_table.rtb-0329e787bbafcb2c4.id,
    aws_route_table.rtb-041267f0474c24068.id,
  ]
  security_group_ids = []
  service_name       = format("com.amazonaws.%s.s3", data.aws_region.current.name)
  subnet_ids         = []
  tags               = {}
  vpc_endpoint_type  = "Gateway"
  vpc_id             = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ssm:
resource "aws_vpc_endpoint" "vpce-ssm" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ssm", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-ssmmessages:
resource "aws_vpc_endpoint" "vpce-ssmmessages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.ssmmessages", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}
# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_vpc_endpoint.vpce-sts:
resource "aws_vpc_endpoint" "vpce-sts" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    aws_security_group.allnodes-sg.id,
    aws_security_group.cluster-sg.id
  ]
  service_name = format("com.amazonaws.%s.sts", data.aws_region.current.name)
  subnet_ids = [
    aws_subnet.subnet-i3.id,
    aws_subnet.subnet-i1.id,
    aws_subnet.subnet-i2.id,
  ]
  tags              = {}
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.cluster.id

  timeouts {}
}


