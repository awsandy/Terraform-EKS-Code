# kubernetes_deployment.howto-k8s-ingress-gateway__green:
resource "kubernetes_deployment" "howto-k8s-ingress-gateway__green" {

  metadata {
    annotations = {}
    labels      = {}
    name        = "green"
    namespace   = "howto-k8s-ingress-gateway"
  }

  spec {
    min_ready_seconds         = 0
    paused                    = false
    progress_deadline_seconds = 600
    replicas                  = "1"
    revision_history_limit    = 10

    selector {
      match_labels = {
        "app"     = "color"
        "version" = "green"
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
        labels = {
          "app"     = "color"
          "version" = "green"
        }
      }

      spec {
        automount_service_account_token  = false
        dns_policy                       = "ClusterFirst"
        enable_service_links             = false
        host_ipc                         = false
        host_network                     = false
        host_pid                         = false
        node_selector                    = {}
        restart_policy                   = "Always"
        share_process_namespace          = false
        termination_grace_period_seconds = 30

        container {
          args                       = []
          command                    = []
          image= format("%s.dkr.ecr.%s.amazonaws.com/howto-k8s-ingress-gateway/colorapp", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
          image_pull_policy          = "Always"
          name                       = "app"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          env {
            name  = "COLOR"
            value = "green"
          }

          port {
            container_port = 8080
            protocol       = "TCP"
          }

          resources {}
        }
      }
    }
  }

  timeouts {}
}
