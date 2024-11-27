variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "zone_id" {
  description = "Route 53 Zone ID"
  type        = string
}
