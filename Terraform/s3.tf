resource "aws_s3_bucket" "bucket" {
  bucket = "lambda-bucket"
}

locals {
  files_to_upload = fileset("./images/", "images/*.jpg")
}

resource "aws_s3_bucket_object" "files" {
  for_each = { for file in local.files_to_upload : file => file }

  bucket = aws_s3_bucket.bucket.id
  key    = each.value
  source = "./images/${each.value}"
}
