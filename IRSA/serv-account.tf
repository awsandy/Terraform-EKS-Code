resource "kubernetes_service_account" "default__iam-test" {
automount_service_account_token = false

metadata {
annotations = {
"eks.amazonaws.com/role-arn" = "arn:aws:iam::566972129213:role/eksctl-appmesh1-addon-iamserviceaccount-defa-Role1-I2LZV4H1I1Z3"
}
name = "iam-test"
namespace = "default"
}

}