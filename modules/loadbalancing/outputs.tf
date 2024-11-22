output "alb_arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.coalfire_alb.arn
}

output "target_group_arn" {
  description = "ARN of the target group for instances"
  value       = aws_lb_target_group.coalfire_target_group.arn
}
