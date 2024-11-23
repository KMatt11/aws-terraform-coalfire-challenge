# vpc Output
output "vpc_id" {
  description = "VPC id"
  value       = module.networking.vpc_id
}

# public subnet ids
output "public_subnet_ids" {
  description = "public subnet ids"
  value       = module.networking.public_subnet_ids
}

# private subnet ids
output "private_subnet_ids" {
  description = "private subnet ids"
  value       = module.networking.private_subnet_ids
}

# load balancer dns name
output "lb_dns" {
  description = "DNS name of the application load balancer"
  value       = module.loadbalancing.alb_arn
}

# load balancer arn
output "lb_arn" {
  description = "load balancer arn"
  value       = module.loadbalancing.alb_arn
}

# target group arn
output "target_group_arn" {
  description = "target group arn"
  value       = module.loadbalancing.target_group_arn
}

# s3 logs bucket name
output "s3_logs_bucket_name" {
  description = "s3 logs bucket name"
  value       = module.s3.logs_bucket_name
}

# s3 images bucket name
output "s3_images_bucket_name" {
  description = "s3 images bucket name"
  value       = module.s3.images_bucket_name
}

# s3 logs bucket arn
output "s3_logs_bucket_arn" {
  description = "s3 logs bucket arn"
  value       = module.s3.logs_bucket_arn
}

# s3 images bucket arn
output "s3_images_bucket_arn" {
  description = "s3 images bucket arn"
  value       = module.s3.images_bucket_arn
}

# asg (compute module)
output "asg_name" {
  description = "asg name"
  value       = module.compute.autoscaling_group_name
}

# compute instance profile (s3 write)
output "compute_instance_profile_name" {
  description = "ec2 instances for writing logs to s3"
  value       = module.compute.asg_instance_profile_name
}
