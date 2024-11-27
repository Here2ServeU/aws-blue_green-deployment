variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
