variable "domain_name" {
  description = "The domain name for the DNS zone"
  type        = string
}

variable "record_name" {
  description = "The subdomain or record name"
  type        = string
}

variable "target" {
  description = "Target value for the DNS record (e.g., CloudFront distribution domain)"
  type        = string
}
