# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_appmesh_virtual_router.howto-k8s-ingress-gateway__color-headers_howto-k8s-ingress-gateway:
resource "aws_appmesh_virtual_router" "howto-k8s-ingress-gateway__color-headers_howto-k8s-ingress-gateway" {
  mesh_name  = "howto-k8s-ingress-gateway"
  mesh_owner = data.aws_caller_identity.current.account_id
  name       = "color-headers_howto-k8s-ingress-gateway"
  tags       = {}

  spec {
    listener {
      port_mapping {
        port     = 8080
        protocol = "http"
      }
    }
  }
}
