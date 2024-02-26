resource "aws_iam_role" "ec2s3acess" {
  name = var.iamrole

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = var.iamrole
  }
}

resource "aws_iam_instance_profile" "activesg_profile" {
  name = var.instance_profile
  role = aws_iam_role.ec2s3acess.name
}

resource "aws_iam_role_policy" "activesgs3_policy" {
  name = var.iam_role_policy
  role = aws_iam_role.ec2s3acess.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}