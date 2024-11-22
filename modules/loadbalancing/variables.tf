variable "public_sg" {
  description = "security group ID for the load balancer"
  type        = string
}

variable "public_subnets" {
  description = "public subnet"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Project = "coalfire"
    Environment = "dev"
  }
}
