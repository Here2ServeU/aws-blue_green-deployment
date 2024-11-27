output "blue_bucket_name" {
  description = "The name of the Blue environment S3 bucket"
  value       = module.s3_blue.bucket_name
}

output "green_bucket_name" {
  description = "The name of the Green environment S3 bucket"
  value       = module.s3_green.bucket_name
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_domain_name
}

output "dns_record" {
  description = "The DNS record created for the CloudFront distribution"
  value       = module.dns.dns_record
}
