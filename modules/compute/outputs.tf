# compute outputs.tf

output "private_asg" {
  description = "auto scaling group for the private instances"
  value       = aws_autoscaling_group.coalfire_private_asg
}
