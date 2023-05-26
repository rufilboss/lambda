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


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.notification.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".jpg"
  }
}

resource "aws_sns_topic_subscription" "toemail" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = "rufilboy@gmail.com"
}



/* resource "aws_sns_topic" "notification" {
  name = "lambda-gif-bucket-notification"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = "rufilboy@gmail.com"
}

resource "aws_s3_bucket_notification" "lambda_notification" {
  bucket = "lambda-gif-bucket"

  topic {
    topic_arn = aws_sns_topic.notification.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_s3_bucket.bucket]
}

# Add the necessary policy to allow S3 to publish notifications to the SNS topic

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3ToPublishNotifications"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "SNS:Publish"
        ]
        Resource = aws_sns_topic.notification.arn
      },
    ]
  })
}

 */




/* resource "aws_sns_topic" "notification" {
  name = "lambda-gif-bucket-notification"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.notification.arn
  protocol  = "email"
  endpoint  = "rufilboy@gmail.com"
}

resource "aws_s3_bucket_notification" "lambda_notification" {
  bucket = "lambda-gif-bucket"

  topic {
    topic_arn = aws_sns_topic.notification.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_s3_bucket.bucket]
} */
