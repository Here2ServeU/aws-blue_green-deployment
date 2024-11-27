module "s3_blue" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-blue"
  tags        = {
    environment = "dev"
    owner       = "t2s"
  }
  index_file  = "blue-index.html"
}

module "s3_green" {
  source      = "../../modules/s3_bucket"
  name        = "t2s-services-green"
  tags        = {
    environment = "dev"
    owner       = "t2s"
  }
  index_file  = "green-index.html"
}
