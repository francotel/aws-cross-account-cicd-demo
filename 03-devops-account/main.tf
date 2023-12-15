locals {
  github_oidc_domain = "token.actions.githubusercontent.com"
  reponame           = "francotel/aws-cross-account-cicd-demo"
}

# IAM Role
resource "aws_iam_role" "github_actions" {
  name               = "GitHubActions-${var.env}"
  description        = "GitHub Actions"
  assume_role_policy = data.aws_iam_policy_document.assume_github.json
}

resource "aws_iam_role_policy_attachment" "github_actions1" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "sts" {
  name   = "sts-policy-${var.env}"
  role   = aws_iam_role.github_actions.name
  policy = data.aws_iam_policy_document.sts.json
}

data "aws_iam_policy_document" "sts" {
  statement {
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_github" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:TagSession"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "${local.github_oidc_domain}:sub"
      values   = ["repo:${local.reponame}:*"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.github_oidc_domain}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
}