data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.bucket.arn]
    }
  }
}
resource "aws_sns_topic" "notification" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_sns_topic_subscription" "toemail" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = "rufilboy@gmail.com"
}
