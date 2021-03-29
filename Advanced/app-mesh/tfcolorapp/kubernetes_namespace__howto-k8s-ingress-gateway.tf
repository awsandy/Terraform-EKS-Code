# kubernetes_namespace.howto-k8s-ingress-gateway:
resource "kubernetes_namespace" "howto-k8s-ingress-gateway" {

  metadata {
    annotations = {}
    labels = {
      "appmesh.k8s.aws/sidecarInjectorWebhook" = "enabled"
      "gateway"                                = "ingress-gw"
      "mesh"                                   = "howto-k8s-ingress-gateway"
    }
    name = "howto-k8s-ingress-gateway"
  }

  timeouts {}
}
