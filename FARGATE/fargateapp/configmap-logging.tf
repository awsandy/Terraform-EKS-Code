# kubernetes_config_map.aws-observability__aws-logging:
resource "kubernetes_config_map" "aws-observability__aws-logging" {
    binary_data = {}
    data        = {
        "output.conf" = <<-EOT
            [OUTPUT]
                Name cloudwatch
                Match *
                region eu-west-1
                log_group_name fluent-bit-cloudwatch1
                log_stream_prefix from-fluent-bit-1-
                auto_create_group true
                sts_endpoint https://sts.eu-west-1.amazonaws.com
                endpoint https://logs.eu-west-1.amazonaws.com  
        EOT
    }
    id          = "aws-observability/aws-logging"

    metadata {
        annotations      = {}
        generation       = 0
        labels           = {}
        name             = "aws-logging"
        namespace        = "aws-observability"
    }
}