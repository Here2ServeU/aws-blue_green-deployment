output "blue_bucket_name" {
  description = "The name of the Blue environment S3 bucket"
  value       = module.s3_blue.bucket_name
}

output "blue_website_endpoint" {
  description = "The website endpoint for the Blue environment"
  value       = module.s3_blue.website_endpoint
}

output "green_bucket_name" {
  description = "The name of the Green environment S3 bucket"
  value       = module.s3_green.bucket_name
}

output "green_website_endpoint" {
  description = "The website endpoint for the Green environment"
  value       = module.s3_green.website_endpoint
}
