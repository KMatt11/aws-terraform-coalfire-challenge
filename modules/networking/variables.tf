# networking variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"]  # sub1 and sub2
}

variable "private_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"]  # sub3 and sub4
}

variable "availability_zones" {
  description = "availability zones to use for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "access_ip" {
  description = "allowed IP for SSH access"
  type        = string
  default     = "0.0.0.0/0" 
}

variable "project_name" {
  description = "name of the project for tagging"
  type        = string
  default     = "coalfire"
}
