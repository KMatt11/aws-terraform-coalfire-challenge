# compute variables.tf

variable "project_name" {
  description = "project name for tagging"
  type        = string
  default     = "coalfire"
}

variable "private_sg" {
  description = "security group ID for the private instances"
  type        = string
}

variable "private_subnets" {
  description = "private subnet IDs for ASG"
  type        = list(string)
}

variable "key_name" {
  description = "name of the SSH key pair"
  type        = string
}

variable "lb_target_group_arn" {
  description = "ARN of the load balancer target group"
  type        = string
}

variable "private_instance_type" {
  description = "instance type for private instances in ASG"
  type        = string
  default     = "t2.micro"
}

variable "images_bucket_arn" {
  description = "ARN s3 bucket for images"
  type        = string
}
