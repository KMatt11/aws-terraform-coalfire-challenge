# compute outputs.tf

output "launch_template_id" {
  description = "id of the launch template for private instances"
  value       = aws_launch_template.coalfire_private.id
}

output "autoscaling_group_name" {
  description = "autoscaling group name for private subnets"
  value       = aws_autoscaling_group.coalfire_private_asg.name
}

output "asg_instance_profile_name" {
  description = "profile for asg"
  value       = aws_iam_instance_profile.coalfire_asg_instance_profile.name
}
