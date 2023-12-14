data "aws_iam_policy_document" "cross_policy" {
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