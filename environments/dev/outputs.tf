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

output "blue_cloudfront_domain_name" {
  description = "The domain name of the Blue CloudFront distribution"
  value       = module.cloudfront_blue.cloudfront_domain_name
}

output "green_cloudfront_domain_name" {
  description = "The domain name of the Green CloudFront distribution"
  value       = module.cloudfront_green.cloudfront_domain_name
}

output "dns_record" {
  description = "The DNS record created in Route 53"
  value       = module.dns.dns_record
}
