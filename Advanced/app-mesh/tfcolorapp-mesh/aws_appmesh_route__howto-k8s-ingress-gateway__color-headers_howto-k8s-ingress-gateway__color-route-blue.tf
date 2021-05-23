# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_appmesh_route.howto-k8s-ingress-gateway__color-headers_howto-k8s-ingress-gateway__color-route-blue:
resource "aws_appmesh_route" "howto-k8s-ingress-gateway__color-headers_howto-k8s-ingress-gateway__color-route-blue" {
  mesh_name           = "howto-k8s-ingress-gateway"
  mesh_owner          = data.aws_caller_identity.current.account_id
  name                = "color-route-blue"
  tags                = {}
  virtual_router_name = "color-headers_howto-k8s-ingress-gateway"

  spec {
    priority = 10

    http_route {
      action {
        weighted_target {
          virtual_node = "blue_howto-k8s-ingress-gateway"
          weight       = 1
        }
      }

      match {
        prefix = "/"

        header {
          invert = false
          name   = "color_header"

          match {
            exact = "blue"
          }
        }
      }
    }
  }
}
