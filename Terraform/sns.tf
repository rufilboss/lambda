resource "aws_sns_topic" "notification" {
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
