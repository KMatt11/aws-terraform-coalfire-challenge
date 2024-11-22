variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "coalfire"
}

variable "environment" {
  description = "environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {
    Name        = "coalfire-bucket"
    Environment = "dev"
  }
}
