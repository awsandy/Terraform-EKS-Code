# kubernetes_service_account.howto-k8s-ingress-gateway__default:
resource "kubernetes_service_account" "howto-k8s-ingress-gateway__default" {
  automount_service_account_token = false

  metadata {
    annotations = {}
    labels      = {}
    name        = "default"
    namespace   = "howto-k8s-ingress-gateway"
  }

  timeouts {}
}
