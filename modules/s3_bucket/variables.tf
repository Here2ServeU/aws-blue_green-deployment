variable "name" {
  description = "Base name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "index_file" {
  description = "Name of the index.html file to upload"
  type        = string
}
