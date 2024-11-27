variable "name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "index_file" {
  description = "Path to the index.html file for the environment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
