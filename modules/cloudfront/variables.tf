variable "origin_domain_name" {
  description = "The domain name of the origin (e.g., S3 bucket endpoint)"
  type        = string
}

variable "origin_id" {
  description = "Unique ID for the origin"
  type        = string
}

variable "origin_access_identity" {
  description = "The CloudFront origin access identity"
  type        = string
}

variable "logging_bucket" {
  description = "S3 bucket for CloudFront access logs"
  type        = string
}

variable "tags" {
  description = "Tags for the CloudFront distribution"
  type        = map(string)
}
