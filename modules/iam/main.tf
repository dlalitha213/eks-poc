
# Example: Create an IAM OIDC provider for GitHub Actions and a role that allows GitHub to assume it.
# IMPORTANT: After creating the OIDC provider, you should restrict the audience/conditions to your org/repo for security.
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's OIDC thumbprint (may change; verify before use)
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Example condition: restrict to a specific repo and branch (replace owner/repo)
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:YOUR_GITHUB_ORG/YOUR_REPOSITORY:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = var.github_oidc_role_name
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

# Minimal policy to allow ECR push, EKS operations, and CloudFormation/EC2 as needed.
resource "aws_iam_policy" "github_actions_policy" {
  name   = "${var.github_oidc_role_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
          "eks:*",
          "ec2:*",
          "iam:PassRole",
          "elasticloadbalancing:*",
          "route53:*",
          "acm:*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}

output "github_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}
output "github_oidc_role_arn" {
  value = aws_iam_role.github_actions.arn
}
