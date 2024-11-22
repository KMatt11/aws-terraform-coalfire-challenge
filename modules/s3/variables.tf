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

variable "bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "coalfire-bucket"
}

variable "acl" {
  description = "ACL for bucket access"
  type        = string
  default     = "private"
}

variable "tags" {
  description = "bucket tags"
  type        = string
  default     = "coalfire-tags"
}
