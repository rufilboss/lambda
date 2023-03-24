resource "aws_lambda_function" "convert_images" {
  filename      = "convert_images.zip"
  function_name = "convert_images_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_handler"
  runtime       = "python3.8"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_policy_"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::your_bucket_name/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_permission" "s3_trigger_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert_images.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::your_bucket_name"
}

resource "aws_s3_bucket_notification" "lambda_notification" {
  bucket = "your_bucket_name"

  lambda_function {
    lambda_function_arn = aws_lambda_function.convert_images.arn
    events              = ["s3:ObjectCreated:*"]
  }
}