resource "aws_launch_template" "web_server" {
  name_prefix   = "web-server-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.web_server.name
  }

  network_interfaces {
    security_groups = [aws_security_group.web_server.id]
    subnet_id       = element(module.alb_lab_vpc.private_subnets, 0)
  }

  user_data = filebase64("user_data.sh")  
}

resource "aws_autoscaling_group" "web_server" {
  name                      = "web-server-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  vpc_zone_identifier       = module.alb_lab_vpc.private_subnets

  # Ensure the ASG is created after the VPC and nat_gateway
  depends_on = [ module.alb_lab_vpc ]
  
}

resource "aws_autoscaling_attachment" "web_server" {
  autoscaling_group_name = aws_autoscaling_group.web_server.id
  lb_target_group_arn    = aws_lb_target_group.web_server.arn
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_security_group" "web_server" {
  name        = "web-sg"
  description = "Allow HTTP traffic from ALB security group"
  vpc_id      = module.alb_lab_vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_load_balancer.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_instance_profile" "web_server" {
  name = "web_server_instance_profile"
  role = aws_iam_role.web_server.name
}

resource "aws_iam_role" "web_server" {
  name = "web-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "web_server" {
  role       = aws_iam_role.web_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}