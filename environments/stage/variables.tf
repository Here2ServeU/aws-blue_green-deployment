variable "environment" {
  description = "Stage Environment"
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
