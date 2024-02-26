resource "aws_lb_target_group" "activesgtg" {
  name        = var.target_group
  port        = var.port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path    = "/"
    matcher = 200
  }
}
resource "aws_lb" "activesg-lb" {
  name               = var.load_balancer
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "activesg-lb"
  }
}

resource "aws_lb_listener" "activesg_alblis" {
  load_balancer_arn = aws_lb.activesg-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.activesgtg.arn
  }
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.activesg-lb.dns_name
}

output "target_group_arns" {
  value = aws_lb_target_group.activesgtg.arn
}
output "public_url" {
  value = "http://${aws_lb.activesg-lb.dns_name}:80"
}