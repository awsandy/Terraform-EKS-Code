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
  namespace = kubernetes_namespace.appmesh-system.metadata[0].name

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks_cluster.name
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
  }

  set {
    name  = "serviceAccount.name"
    value = "appmesh-controller"
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon/appmesh-controller"
  }

}

