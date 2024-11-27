resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${terraform.workspace}"

  tags = var.tags
}

resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "${path.module}/${var.index_file}"
  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
          }
        }
      }
    ]
  })
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

data "aws_caller_identity" "current" {}
