resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    s3_origin_config {
      origin_access_identity = var.origin_access_identity
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    compress = true
  }

  price_class = "PriceClass_100"

  tags = var.tags
}
