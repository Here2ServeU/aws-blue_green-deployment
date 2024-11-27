resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${terraform.workspace}"
  acl    = "private"

  website {
    index_document = "index.html"
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
    }
  ]
}
EOT
}
