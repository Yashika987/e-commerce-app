resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubActionsOIDCRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Yashika987/e-commerce-app:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# Attach IAM Policy to the Role
resource "aws_iam_role_policy" "github_oidc_policy" {
  name = "GitHubActionsOIDCPolicy"
  role = aws_iam_role.github_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "ec2:*",
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}