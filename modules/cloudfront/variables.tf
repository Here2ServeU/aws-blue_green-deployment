variable "origin_domain_name" {
  description = "The domain name of the origin"
  type        = string
}

variable "origin_id" {
  description = "The ID of the origin"
  type        = string
}

variable "origin_access_identity" {
  description = "The CloudFront Origin Access Identity"
  type        = string
}

variable "tags" {
  description = "Tags for the CloudFront distribution"
  type        = map(string)
  default     = {}
}
