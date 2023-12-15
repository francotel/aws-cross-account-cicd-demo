resource "aws_iam_role" "cross_role" {
  name               = "cross-role-target-${var.env}"
  description        = "Used by github to deploy infrastructure"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.devops_account_id]
    }
  }

}

# Cross Role policy
resource "aws_iam_role_policy" "attach_codepipeline_policy" {
  name   = "policy-deploy-cicd-infra-${var.env}"
  role   = aws_iam_role.cross_role.id
  policy = data.aws_iam_policy_document.cross_policy.json
}

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