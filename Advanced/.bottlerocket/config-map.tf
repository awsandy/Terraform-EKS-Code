locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${data.terraform_remote_state.iam.outputs.nodegroup_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}




resource "local_file" "aws_auth_configmap" {
  content              = local.config_map_aws_auth
  filename             = "config_map_aws_auth.yaml"
  file_permission      = "0644"
}

