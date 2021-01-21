### Enabling IAM Roles for Service Accounts
data "aws_iam_policy_document" "cluster_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      #values   = ["system:serviceaccount:kube-system:aws-node"]
      values   = [format("system:serviceaccount:%s:%s",var.namespace,var.sa-name)]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}