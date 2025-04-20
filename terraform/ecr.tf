#  Create ECR Repository
resource "aws_ecr_repository" "easyshop_repo" {
  name = "easyshop-repo"
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = "IMMUTABLE"
}

# Create IAM Policy for ECR Access
resource "aws_iam_policy" "easyshop_ecr_access_policy" {
  name = "EasyShopECRAccessPolicy"
  description = "Allow GitHub Actions to push and pull to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ],
        Resource: "*"
      }
    ]
  })
}

# Attach IAM Policy to existing GitHub OIDC Role
resource "aws_iam_role_policy_attachment" "attach_ecr_policy_to_github_oidc" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.easyshop_ecr_access_policy.arn
}

# Set a Lifecycle Policy for ECR (only 1 image kept)
resource "aws_ecr_lifecycle_policy" "easyshop_repo_lifecycle" {
  repository = aws_ecr_repository.easyshop_repo.name

  policy = jsonencode({
    rules: [
      {
        rulePriority: 1,
        description: "Keep only last 1 image",
        selection: {
          tagStatus: "any",
          countType: "imageCountMoreThan",
          countNumber: 1
        },
        action: {
          type: "expire"
        }
      }
    ]
  })
}
