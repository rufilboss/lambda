resource "aws_s3_bucket" "bucket" {
  bucket = "lambda-bucket"
}

locals {
  files_to_upload = fileset("./images/")
}

resource "aws_s3_bucket_object" "files" {
  for_each = { for file in locals.files_to_upload : file => file }

  bucket = aws_s3_bucket.my_bucket.id
  key    = each.value
  source = "./images/${each.value}"
}
