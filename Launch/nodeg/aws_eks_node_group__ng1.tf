# File generated by aws2tf see https://github.com/aws-samples/aws2tf

data "aws_subnet_ids" "private" {
    vpc_id = data.terraform_remote_state.net.outputs.eks-vpc
    tags = {
        "subnet-type"  = "private"
    }
}



resource "aws_eks_node_group" "ng1" {
  #ami_type       = "AL2_x86_64"
  depends_on     = [aws_launch_template.lt-ng1]
  cluster_name   = data.aws_eks_cluster.eks_cluster.name
  disk_size      = 0
  instance_types = []
  labels = {
    "eks/cluster-name"   = data.aws_eks_cluster.eks_cluster.name
    "eks/nodegroup-name" = format("%s-ng1-%s", data.aws_eks_cluster.eks_cluster.name,var.tfid)
  }
  node_group_name = format("%s-ng1-%s", data.aws_eks_cluster.eks_cluster.name,var.tfid)
  node_role_arn   = data.terraform_remote_state.iam.outputs.nodegroup_role_arn

  subnet_ids      = concat(sort(data.aws_subnet_ids.private.ids))

  tags = {
    "eks/cluster-name"                            = data.aws_eks_cluster.eks_cluster.name
    "eks/nodegroup-name"                          = format("%s-ng1-%s", data.aws_eks_cluster.eks_cluster.name,var.tfid)
    "eks/nodegroup-type"                          = "managed"
  }

  launch_template {
    name    = aws_launch_template.lt-ng1.name
    version = "1"
  }

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  timeouts {}
}
