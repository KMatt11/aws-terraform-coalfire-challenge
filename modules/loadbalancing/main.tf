# loadbalancing main.tf

# application load balancer
resource "aws_lb" "coalfire_alb" {
  name               = "coalfire-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = var.public_subnets

  tags = {
    Name = "coalfire-alb"
  }
}

# target group for auto scaling group instances
resource "aws_lb_target_group" "coalfire_target_group" {
  name     = "coalfire-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "coalfire-target-group"
  }
}

# listener for load balancer
resource "aws_lb_listener" "coalfire_listener" {
  load_balancer_arn = aws_lb.coalfire_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.coalfire_target_group.arn
  }
}
