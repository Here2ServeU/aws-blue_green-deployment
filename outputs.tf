output "blue_bucket_name" {
  value = module.s3_blue.bucket_name
}

output "green_bucket_name" {
  value = module.s3_green.bucket_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}

output "dns_record" {
  value = module.dns.dns_record
}
