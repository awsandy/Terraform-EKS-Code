# kubernetes_service.howto-k8s-ingress-gateway__ingress-gw:
resource "kubernetes_service" "howto-k8s-ingress-gateway__ingress-gw" {
  metadata {
    annotations = {}
    labels      = {}
    name        = "ingress-gw"
    namespace   = "howto-k8s-ingress-gateway"
  }

  spec {
    cluster_ip                  = "10.100.50.147"
    external_ips                = []
    external_traffic_policy     = "Cluster"
    health_check_node_port      = 0
    load_balancer_source_ranges = []
    publish_not_ready_addresses = false
    selector = {
      "app" = "ingress-gw"
    }
    session_affinity = "None"
    type             = "LoadBalancer"

    port {
      name        = "http"
      node_port   = 30754
      port        = 80
      protocol    = "TCP"
      target_port = "8088"
    }
  }

  wait_for_load_balancer = true
  timeouts {}
}
