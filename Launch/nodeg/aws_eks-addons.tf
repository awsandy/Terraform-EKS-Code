
resource "aws_eks_addon" "vpc-cni" {
  depends_on     = [aws_eks_node_group.ng1]
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  #addon_version = "v1.9.0-eksbuild.1"
}

resource "aws_eks_addon" "kube-proxy" {
  depends_on     = [aws_eks_node_group.ng1]
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns" {
  depends_on     = [aws_eks_node_group.ng1]
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}