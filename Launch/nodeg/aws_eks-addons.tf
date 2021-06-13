
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = data.aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}