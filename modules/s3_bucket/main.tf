module "s3_blue" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-blue"
  tags        = {
    environment = var.environment
  }
  index_file  = var.index_file
}

module "s3_green" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-green"
  tags        = {
    environment = var.environment
  }
  index_file  = var.index_file
}

resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = var.index_file
  content_type = "text/html"
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
