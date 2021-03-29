# kubernetes_deployment.howto-k8s-ingress-gateway__blue:
resource "kubernetes_deployment" "howto-k8s-ingress-gateway__blue" {

  metadata {
    annotations = {}
    labels      = {}
    name        = "blue"
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
        "version" = "blue"
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
          "version" = "blue"
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
          image                      = "566972129213.dkr.ecr.eu-west-1.amazonaws.com/howto-k8s-ingress-gateway/colorapp"
          image_pull_policy          = "Always"
          name                       = "app"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          env {
            name  = "COLOR"
            value = "blue"
          }

          port {
            container_port = 8080
            host_port      = 0
            protocol       = "TCP"
          }

          resources {}
        }
      }
    }
  }

  timeouts {}
}
