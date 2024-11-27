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

resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = var.index_file
  content_type = "text/html"
}
