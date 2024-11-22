# compute variables.tf

variable "private_sg" {
  description = "security group ID for the private instances"
  type        = string
}

variable "private_subnet" {
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