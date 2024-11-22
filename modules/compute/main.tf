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

# AMI data source to get the most recent red hat linux AMI
data "aws_ami" "rhel_8_5" {
  most_recent = true
  owners = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# launch template for the private instances
resource "aws_launch_template" "coalfire_private" {
  name_prefix            = "coalfire_private"
  image_id               = data.aws_ami.rhel_8_5.id
  instance_type          = var.private_instance_type
  vpc_security_group_ids = [var.private_sg]
  key_name               = var.key_name
  user_data              = filebase64("apache.sh")

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

  tags = [
    {
      key                 = "Name"
      value               = "coalfire-private-asg"
      propagate_at_launch = true
    }
  ]

  iam_instance_profile = aws_iam_instance_profile.coalfire_asg_instance_profile.name
}

# attach the auto scaling group to load balancer target group
resource "aws_autoscaling_attachment" "coalfire_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.coalfire_private_asg.id
  lb_target_group_arn    = var.lb_target_group_arn
}

# IAM role for asg to read from s3 
resource "aws_iam_role" "coalfire_asg_s3_read_role" {
  name               = "${var.project_name}-asg-s3-read-role"
  assume_role_policy = data.aws_iam_policy_document.coalfire_ec2_assume_role.json
}

# IAM policy for asg to read from s3
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

# IAM policy attachment for asg
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
