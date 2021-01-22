# attach cluster trust policy  to role
resource "aws_iam_role" "irsa-s3-test" {
  assume_role_policy = data.aws_iam_policy_document.cluster_trust_policy.json
  name               = "irsa-s3-test"
}

# attach ReadOnly policy to role
resource "aws_iam_role_policy_attachment" "irsa-s3-test-attach" {
  role       = aws_iam_role.irsa-s3-test.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}