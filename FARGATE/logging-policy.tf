resource "aws_iam_policy" "eks-fargate-logging-policy" {
  name        = "eks-fargate-logging-policy"
  path        = "/"
  description = "eks-fargate-logging-policy"

  policy = file("logging-policy.json")
  
}