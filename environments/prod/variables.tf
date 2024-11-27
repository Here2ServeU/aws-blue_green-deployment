variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)"
  type        = string
}

variable "zone_id" {
  description = "Route 53 Zone ID"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
