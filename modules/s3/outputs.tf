output "bucket_arn" {
  description = "s3 bucket ARN"
  value       = aws_s3_bucket.coalfire_project_bucket.arn
}

output "bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.coalfire_project_bucket.bucket
}

output "write_logs_policy_arn" {
  description = "write logs policy ARN"
  value       = aws_iam_policy.coalfire_write_logs_policy.arn
}

output "ec2_instance_profile_name" {
  description = "ec2 profile for writing logs"
  value       = aws_iam_instance_profile.coalfire_ec2_instance_profile.name
}
