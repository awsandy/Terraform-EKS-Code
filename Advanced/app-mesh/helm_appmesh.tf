provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "appmesh-controller" {
  name       = "appmesh-controller"
  depends_on=[null_resource.post-policy]

  repository = "https://aws.github.io/eks-charts"
  chart      = "appmesh-controller"
  namespace = "appmesh-system"

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks_cluster.name
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "accountId"
    value = data.aws_caller_identity.current.account_id
  }

  set {
    name  = "serviceAccount.name"
    value = "appmesh-controller"
  }

  set {
    name  = "image.repository"
    value = format("%s.dkr.ecr.%s.amazonaws.com/amazon/appmesh-controller",data.aws_caller_identity.current.account_id,data.aws_region.current.name)
  }

}

