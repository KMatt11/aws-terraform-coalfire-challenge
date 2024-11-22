# compute main.tf

# IAM assume role policy document for EC2
data "aws_iam_policy_document" "coalfire_ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# launch template for private instances
resource "aws_launch_template" "coalfire_private" {
  name_prefix            = "coalfire_private"
  image_id               = "ami-08d658f84a6d84a80"  
  instance_type          = var.private_instance_type
  vpc_security_group_ids = [var.private_sg]
  key_name               = var.key_name
  user_data              = filebase64("${path.module}/apache.sh") 

  tags = {
    Name = "coalfire-private-instance"
  }
}

# auto scaling group for the private subnets (sub3 and sub4)
resource "aws_autoscaling_group" "coalfire_private_asg" {
  name                = "coalfire_private_asg"
  vpc_zone_identifier = tolist(var.private_subnets)
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.coalfire_private.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "coalfire-private-asg"
    propagate_at_launch = true
  }
}

# attach the auto scaling group to load balancer target group
resource "aws_autoscaling_attachment" "coalfire_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.coalfire_private_asg.id
  lb_target_group_arn    = var.lb_target_group_arn
}

# iam role for asg
resource "aws_iam_role" "coalfire_asg_s3_read_role" {
  name               = "${var.project_name}-asg-s3-read-role"
  assume_role_policy = data.aws_iam_policy_document.coalfire_ec2_assume_role.json
}

# iam policy for asg
resource "aws_iam_policy" "coalfire_s3_read_policy" {
  name        = "${var.project_name}-s3-read-policy"
  description = "Policy to allow ASG instances to read from images bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${var.images_bucket_arn}/*"
      }
    ]
  })
}

# policy attachment for asg
resource "aws_iam_policy_attachment" "coalfire_asg_s3_read_attach" {
  name       = "${var.project_name}-asg-s3-read-attach"
  roles      = [aws_iam_role.coalfire_asg_s3_read_role.name]
  policy_arn = aws_iam_policy.coalfire_s3_read_policy.arn
}

# instance profile for asg
resource "aws_iam_instance_profile" "coalfire_asg_instance_profile" {
  name = "${var.project_name}-asg-instance-profile"
  role = aws_iam_role.coalfire_asg_s3_read_role.name
}
