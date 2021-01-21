resource "kubernetes_service_account" "default__iam-test" {
automount_service_account_token = false

metadata {
annotations = {
"eks.amazonaws.com/role-arn" = aws_iam_role.irsa-s3-test.arn
}
name = "iam-test"
namespace = "default"
}

}