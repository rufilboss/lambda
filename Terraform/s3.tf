resource "aws_s3_bucket" "bucket" {
  bucket = "lambda-gif-bucket"
  force_destroy = true
}

resource "aws_s3_bucket" "dest_bucket" {
  bucket = "lambda-gif-dest-bucket"
  force_destroy = true
  
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.convert_images.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "lambda-gif-bucket"
  }

  depends_on = [ aws_lambda_permission.s3_trigger_permission ]
}










/* locals {
  files_to_upload = fileset("${path.root}/../images", "../images/*.jpg")
}

resource "aws_s3_bucket_object" "files" {
  for_each = { for file in local.files_to_upload : file => file }

  bucket = aws_s3_bucket.bucket.id
  key    = each.value
  source = "${path.root}/../images/${each.value}"

  depends_on = [aws_s3_bucket.bucket]
} */
