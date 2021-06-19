# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_eks_cluster.cluster:


resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  name = var.cluster-name

  role_arn = data.terraform_remote_state.iam.outputs.cluster_service_role_arn
  tags     = {}
  version  = "1.20"

  timeouts {}

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs = [
      "0.0.0.0/0",
    ]
    security_group_ids = [
      data.terraform_remote_state.net.outputs.cluster-sg,
    ]
    subnet_ids = [
      data.terraform_remote_state.net.outputs.sub-priv1,
      data.terraform_remote_state.net.outputs.sub-priv2,
      data.terraform_remote_state.net.outputs.sub-priv3,
    ]
  }

  encryption_config  {
    provider  {
      key_arn = aws_kms_key.ekskey.arn
    }
    resources = ["secrets"]
  }



}

output "cluster-name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster-sg" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

output "ca" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}