variable "zone_id" {
  description = "Route 53 Zone ID"
  type        = string
}

variable "record_name" {
  description = "Record name"
  type        = string
}

variable "target" {
  description = "Target value for the DNS record"
  type        = string
}
