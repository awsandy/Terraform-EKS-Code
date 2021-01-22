### Enabling IAM Roles for Service Accounts
data "aws_iam_policy_document" "cluster_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      # cluster issuer is iodc url
      variable = "${replace(data.aws_eks_cluster.mycluster1.identity.0.oidc.0.issuer,"https://", "")}:sub"
      #variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      #values   = ["system:serviceaccount:kube-system:aws-node"]
      values   = [format("system:serviceaccount:%s:%s",var.namespace,var.sa-name)]
    }

    principals {
      # this has to be an output from the oidc provider create (no data resource in TF)
      identifiers = [data.terraform_remote_state.cluster.outputs.oidc_provider_arn]
      type        = "Federated"
    }
  }
}