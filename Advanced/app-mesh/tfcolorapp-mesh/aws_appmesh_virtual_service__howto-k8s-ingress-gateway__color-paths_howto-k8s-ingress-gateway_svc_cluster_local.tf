# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_appmesh_virtual_service.howto-k8s-ingress-gateway__color-paths_howto-k8s-ingress-gateway_svc_cluster_local:
resource "aws_appmesh_virtual_service" "howto-k8s-ingress-gateway__color-paths_howto-k8s-ingress-gateway_svc_cluster_local" {
  mesh_name  = "howto-k8s-ingress-gateway"
  mesh_owner = data.aws_caller_identity.current.account_id
  name       = "color-paths.howto-k8s-ingress-gateway.svc.cluster.local"
  tags       = {}

  spec {
    provider {

      virtual_router {
        virtual_router_name = "color-paths_howto-k8s-ingress-gateway"
      }
    }
  }
}