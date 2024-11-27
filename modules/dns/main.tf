resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.zone.id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.target]
}
