# kubernetes_service.howto-k8s-ingress-gateway__color-paths:
resource "kubernetes_service" "howto-k8s-ingress-gateway__color-paths" {
  metadata {
    annotations = {}
    labels      = {}
    name        = "color-paths"
    namespace   = "howto-k8s-ingress-gateway"
  }

  spec {
    cluster_ip                  = "10.100.154.149"
    external_ips                = []
    health_check_node_port      = 0
    load_balancer_source_ranges = []
    publish_not_ready_addresses = false
    selector                    = {}
    session_affinity            = "None"
    type                        = "ClusterIP"

    port {
      name        = "http"
      node_port   = 0
      port        = 8080
      protocol    = "TCP"
      target_port = "8080"
    }
  }

  wait_for_load_balancer = true
  timeouts {}
}
