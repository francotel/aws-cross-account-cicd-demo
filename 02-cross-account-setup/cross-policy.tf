data "aws_iam_policy_document" "cross_policy" {
  statement {
    sid = "S3AccessBackend"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::across-account-terraform-state-backend"
    ]
  }
  

  statement {
    sid = "CloudWatchLogsPolicy"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "IamPassPolicy"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
}