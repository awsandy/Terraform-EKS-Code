# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_appmesh_virtual_node.howto-k8s-ingress-gateway__red_howto-k8s-ingress-gateway:
resource "aws_appmesh_virtual_node" "howto-k8s-ingress-gateway__red_howto-k8s-ingress-gateway" {
  mesh_name  = "howto-k8s-ingress-gateway"
  mesh_owner = data.aws_caller_identity.current.account_id
  name       = "red_howto-k8s-ingress-gateway"
  tags       = {}

  spec {

    listener {

      health_check {
        healthy_threshold   = 2
        interval_millis     = 5000
        path                = "/ping"
        port                = 8080
        protocol            = "http"
        timeout_millis      = 2000
        unhealthy_threshold = 2
      }

      port_mapping {
        port     = 8080
        protocol = "http"
      }
    }

    service_discovery {

      dns {
        hostname = "color-red.howto-k8s-ingress-gateway.svc.cluster.local"
      }
    }
  }
}
