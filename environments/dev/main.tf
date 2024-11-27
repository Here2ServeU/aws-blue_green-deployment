module "dns" {
  source      = "../../modules/dns"
  domain_name = "t2s-services.com"
  record_name = "www"
  target      = module.cloudfront_blue.cloudfront_domain_name
}

module "s3_blue" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-blue"
  tags        = {
    environment = "dev"
    service     = "t2s-services"
  }
  index_file  = "blue-index.html"
}

module "s3_green" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-green"
  tags        = {
    environment = "dev"
    service     = "t2s-services"
  }
  index_file  = "green-index.html"
}

module "cloudfront_blue" {
  source                = "../../modules/cloudfront"
  origin_domain_name    = module.s3_blue.website_endpoint
  origin_id             = "S3-t2s-services-blue"
  origin_access_identity = "origin-access-identity/cloudfront/E34EXAMPLEOAI"
  logging_bucket        = "t2s-cloudfront-logs"
  tags = {
    environment = "dev"
    service     = "t2s-services"
  }
}

module "cloudfront_green" {
  source                = "../../modules/cloudfront"
  origin_domain_name    = module.s3_green.website_endpoint
  origin_id             = "S3-t2s-services-green"
  origin_access_identity = "origin-access-identity/cloudfront/E34EXAMPLEOAI"
  logging_bucket        = "t2s-cloudfront-logs"
  tags = {
    environment = "dev"
    service     = "t2s-services"
  }
}
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "t2s-cloudfront-logs"
  tags = {
    environment = "dev"
    service     = "t2s-services"
  }
}

resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::t2s-cloudfront-logs/*"
      }
    ]
  })
}
