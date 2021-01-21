resource "kubernetes_job" "default__eks-iam-test-s3" {

  metadata {
    annotations = {}
    labels = {
      "app" = "eks-iam-test-s3"
    }
    name      = "eks-iam-test-s3"
    namespace = "default"
  }

  spec {
    backoff_limit   = 6
    completions     = 1
    manual_selector = false
    parallelism     = 1

    selector {
    }

    template {
      metadata {
        annotations = {}
        labels = {
          "app" = "eks-iam-test-s3"
        }
      }

      spec {
        automount_service_account_token  = false
        dns_policy                       = "ClusterFirst"
        enable_service_links             = true
        host_ipc                         = false
        host_network                     = false
        host_pid                         = false
        node_selector                    = {}
        restart_policy                   = "Never"
        service_account_name             = kubernetes_service_account.default__iam-test.name
        share_process_namespace          = false
        termination_grace_period_seconds = 30

        container {
          args = [
            "s3",
            "ls",
          ]
          command                    = []
          #image                      = "amazon/aws-cli:latest"
          image             = format("%s.dkr.ecr.%s.amazonaws.com/aws-cli", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
          image_pull_policy          = "Always"
          name                       = "eks-iam-test"
          stdin                      = false
          stdin_once                 = false
          termination_message_path   = "/dev/termination-log"
          termination_message_policy = "File"
          tty                        = false

          resources {
          }
        }
      }
    }
  }

}
