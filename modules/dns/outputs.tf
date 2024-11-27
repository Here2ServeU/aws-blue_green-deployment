output "zone_id" {
  description = "The ID of the DNS zone"
  value       = aws_route53_zone.zone.id
}

output "dns_record" {
  description = "The fully qualified domain name of the record"
  value       = aws_route53_record.cname.fqdn
}
