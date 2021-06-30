# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_iam_role_policy.eks-nodegroup-role__eks-nodegroup-ng-maneksami2-PolicyEFS:
resource "aws_iam_role_policy" "eks-nodegroup-role__eks-nodegroup-ng-maneksami2-PolicyEFS" {
  name = "eks-nodegroup-ng-maneksami2-PolicyEFS"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "elasticfilesystem:*",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.eks-nodegroup-role.id
}
