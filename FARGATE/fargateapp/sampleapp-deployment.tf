

resource "kubernetes_deployment" "fargate1__deployment-2048" {

  metadata {
    name      = "deployment-2048"
    namespace = kubernetes_namespace.fargate1.name
  }

  timeouts {   
    create = "3m"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "app-2048"
      }
    }
    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        annotations = {}
        labels      = { "app.kubernetes.io/name" = "app-2048" }
      }

      spec {



        container {
          image             = format("%s.dkr.ecr.%s.amazonaws.com/sample-app", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
          image_pull_policy = "Always"
          name              = "app-2048"
          port {
            container_port = 80
            host_port      = 0
            protocol       = "TCP"
          }

          resources {
          }
        }
      }
    }
  }


}


