resource "aws_kms_key" "ekskey" {
  enable_key_rotation = true
  description         = format("EKS KMS Key %s tfid=%s", var.cluster-name, random_id.id1.hex)
}

resource "aws_kms_alias" "a" {
  name          = format("alias/eks-key-%s-%s", var.cluster-name, random_id.id1.hex)
  target_key_id = aws_kms_key.ekskey.id
}


