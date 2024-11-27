output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket
}

resource "aws_s3_bucket_website" "website_config" {
  bucket = aws_s3_bucket.bucket.id
}

output "website_endpoint" {
  description = "The website endpoint for the S3 bucket"
  value       = aws_s3_bucket_website.website_config.website_endpoint
}
