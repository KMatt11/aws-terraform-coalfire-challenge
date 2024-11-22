# root variables.tf

# project name
variable "project_name" {
  description = "project name for tagging resources."
  type        = string
  default     = "coalfire"
}

# region for resources 
variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

# environment (dev, staging, prod)
variable "environment" {
  description = "environment for the infrastructure (dev, staging, prod)."
  type        = string
  default     = "dev"
}

# CIDR blocks for public subnets
variable "public_cidrs" {
  description = "list of public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.1.0.0/24", "10.1.1.0/24"] # Sub1 and Sub2 (Public)
}

# CIDR blocks for private subnets
variable "private_cidrs" {
  description = "list of private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.1.2.0/24", "10.1.3.0/24"] # Sub3 and Sub4 (Private)
}

# vpc CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the vpc."
  type        = string
  default     = "10.1.0.0/16"
}

# az for subnets
variable "availability_zones" {
  description = "availability zones for the subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# key name for ssh access
variable "key_name" {
  description = "name of the SSH key pair for instances."
  type        = string
}

# access for ssh access
variable "access_ip" {
  description = "IP address allowed to ssh into resources."
  type        = string
  default     = "0.0.0.0/0"
}

# ec2 auto scaling group
variable "private_instance_type" {
  description = "instance type for the ec2 instances in private subnets."
  type        = string
  default     = "t2.micro"
}

# tags for resources
variable "tags" {
  description = "tags used for resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "coalfire"
  }
}
