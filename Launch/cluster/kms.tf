resource "aws_kms_key" "ekskey" {
  description             = format("EKS KMS Key %s",var.cluster-name)
}

output "key_id" {
  value = aws_kms_key.ekskey.key_id
}