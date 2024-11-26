variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  description = "Route 53 Zone ID"
  type        = string
}

variable "logging_bucket" {
  description = "S3 bucket for CloudFront access logs"
  type        = string
}
