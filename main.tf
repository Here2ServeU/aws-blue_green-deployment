module "s3_blue" {
  source = "../modules/s3_bucket"
  name   = "t2s-services-blue"
  tags   = { environment = var.environment }
}

module "s3_green" {
  source = "../modules/s3_bucket"
  name   = "t2s-services-green"
  tags   = { environment = var.environment }
}

module "cloudfront" {
  source                = "../modules/cloudfront"
  origin_domain_name    = module.s3_blue.bucket_name
  origin_id             = "S3-t2s-services-blue"
  origin_access_identity = "origin-access-identity/cloudfront/E34EXAMPLEOAI"
  tags                  = { environment = var.environment }
}

module "dns" {
  source      = "../modules/dns"
  zone_id     = var.zone_id
  record_name = "www.t2s-services.com"
  target      = module.cloudfront.cloudfront_domain_name
}
