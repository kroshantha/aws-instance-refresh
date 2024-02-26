data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Launch Template Resource
resource "aws_launch_template" "activesglt" {
  name          = var.launch_template
  description   = "ActiveSG LT"
  image_id      = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.instance_profile

  }

  vpc_security_group_ids = [var.vpc_security_group_ids]
  user_data              = var.user_data
  ebs_optimized          = false
  update_default_version = true

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "activesgasg"
    }
  }
}

resource "aws_autoscaling_group" "activesgauto" {
  name                = var.autoscaling_group
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3
  target_group_arns   = [var.target_group_arns]
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.activesglt.id
    version = aws_launch_template.activesglt.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  tag {
    key                 = "launch version"
    value               = aws_launch_template.activesglt.latest_version
    propagate_at_launch = true
  }
}