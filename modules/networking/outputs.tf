# networking outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.coalfire_vpc.id
}

output "public_subnet_ids" {
  description = "public subnet IDs"
  value       = aws_subnet.coalfire_public_subnet[*].id
}

output "private_subnet_ids" {
  description = "private subnet IDs"
  value       = aws_subnet.coalfire_private_subnet[*].id
}

output "public_security_group_id" {
  description = "public security group ID for SSH access"
  value       = aws_security_group.coalfire_public_sg.id
}

output "private_security_group_id" {
  description = "private security group ID for internal access"
  value       = aws_security_group.coalfire_private_sg.id
}