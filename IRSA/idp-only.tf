## OIDC Provider
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
#  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url = data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}