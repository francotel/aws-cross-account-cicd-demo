locals {
  github_oidc_domain = "token.actions.githubusercontent.com"
  reponame           = "francotel/aws-cross-account-cicd-demo"
}

resource "aws_iam_role" "cross_role" {
  name               = "cross-role-target-${var.env}"
  description        = "Used by github to deploy infrastructure"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_github.json
}

resource "aws_iam_role_policy" "sts" {
  name   = "sts-policy-${var.env}"
  role   = aws_iam_role.cross_role.name
  policy = data.aws_iam_policy_document.sts.json
}

data "aws_iam_policy_document" "sts" {
  statement {
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

# Cross Role policy
resource "aws_iam_role_policy" "attach_codepipeline_policy" {
  name   = "policy-deploy-cicd-infra-${var.env}"
  role   = aws_iam_role.cross_role.id
  policy = data.aws_iam_policy_document.cross_policy.json
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

# data "aws_iam_role" "cross_account_role" {
#   name = "RoleCrossAccountDynamoDBAccess"
#   # Entra con las credenciales de la cuenta B
# }

# resource "aws_iam_role_policy" "deploy_infra" {

#   name = "Deploy-infrastructure"
#   role = aws_iam_role.cross_act.id

#   #permissions should be least priviledge, AdminAccess used for simplicity
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "Deploy3Tier",
#             "Effect": "Allow",
#             "Action": [
#                 "rds:*",
#                 "s3:*",
#                 "cloudwatch:*",
#                 "wafv2:*",
#                 "logs:*",
#                 "route53:*",
#                 "ec2:*",
#                 "elasticloadbalancing:*",
#                 "autoscaling:*",
#                 "acm:*",
#                 "iam:*"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "AdminAccess",
#             "Effect": "Allow",
#             "Action": "*",
#             "Resource": "*"
#         }
#     ]
# })
# }