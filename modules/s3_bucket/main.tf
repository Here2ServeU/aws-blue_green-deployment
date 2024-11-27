resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${terraform.workspace}"
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "${path.module}/${var.index_file}"
  content_type = "text/html"
}
