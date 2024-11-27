output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "website_endpoint" {
  description = "The website endpoint for the S3 bucket"
  value       = aws_s3_bucket.bucket.website_endpoint
}
