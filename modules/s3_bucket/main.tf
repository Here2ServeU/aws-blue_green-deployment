module "s3_blue" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-blue"
  tags        = {
    environment = var.environment
  }
  index_file  = var.index_file
}

module "s3_green" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-green"
  tags        = {
    environment = var.environment
  }
  index_file  = var.index_file
}
