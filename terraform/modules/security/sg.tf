resource "aws_security_group" "public" {
  name        = var.sg
  description = "Public access"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "activesghttp"
  }
}

resource "aws_security_group_rule" "public_in_http" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

output "sg_id" {
  value = aws_security_group.public.id
}

output "port" {
  value = aws_security_group_rule.public_in_http.from_port
}