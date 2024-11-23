output "logs_bucket_arn" {
  description = "s3 bucket ARN"
  value       = aws_s3_bucket.kinsey-logs.arn
}

output "images_bucket_arn" {
  description = "s3 bucket ARN"
  value       = aws_s3_bucket.kinsey-images.arn
}

output "logs_bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.kinsey-logs.bucket
}

output "images_bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.kinsey-images.bucket
}

output "write_logs_policy_arn" {
  description = "write logs policy ARN"
  value       = aws_iam_policy.coalfire_write_logs_policy.arn
}

output "ec2_instance_profile_name" {
  description = "ec2 profile for writing logs"
  value       = aws_iam_instance_profile.coalfire_ec2_instance_profile.name
}
