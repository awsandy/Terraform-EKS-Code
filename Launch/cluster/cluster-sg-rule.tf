resource "aws_security_group_rule" "eks-add-clustersg" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  security_group_id = data.terraform_remote_state.net.outputs.cluster-sg
}

resource "aws_security_group_rule" "eks-node-cloud9" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc-default.cidr_block]
  security_group_id = data.terraform_remote_state.net.outputs.cluster-sg
}