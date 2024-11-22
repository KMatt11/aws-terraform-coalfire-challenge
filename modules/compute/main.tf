# compute main.tf

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
  vpc_zone_identifier = tolist(var.private_subnet)
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
}

# attach the auto scaling group to load balancer target group
resource "aws_autoscaling_attachment" "coalfire_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.coalfire_private_asg.id
  lb_target_group_arn    = var.lb_target_group_arn
}
