# Creating Security Group for ALB 
resource "aws_security_group" "alb-sg" {
vpc_id = "${aws_vpc.ghostvpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "ALB SG"
  }
}


# Creating Security Group for EC2
resource "aws_security_group" "ec2-sg" {
vpc_id = "${aws_vpc.ghostvpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups  = ["${aws_security_group.alb-sg.id}"]
  }
# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups  = ["${aws_security_group.alb-sg.id}"]
  }
# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "EC2 SG"
  }
}


# Create EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.ec2_ssm_profile}"
  role = "${aws_iam_role.ec2_ssm_role.name}"
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.ec2_ssm_role}"
  assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
    }

resource "aws_iam_role_policy_attachment" "ec2-ssm-policy" {
  role       = "${aws_iam_role.ec2_ssm_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# Create Launch Template
resource "aws_launch_template" "ghostLaunchTemplate" {
  name = "GhostLaunchTemplate"
  iam_instance_profile {
    arn = "${aws_iam_instance_profile.ec2_ssm_profile.arn}"
  }
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Ghost Website"
    }
  }
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {}))
}

# Create Auto Scaling Policy
resource "aws_autoscaling_policy" "ghost_auto_scaling_policy" {
  name                   = "Ghost Target Tracking Policy"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }  
  target_value = "${var.cpu_target_value}"
  }
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.ghost_asg.name
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "ghost_asg" {
  name = "Ghost ASG"  
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier = ["${aws_subnet.application-subnet-a.id}", "${aws_subnet.application-subnet-b.id}"]
  launch_template {
    id      = "${aws_launch_template.ghostLaunchTemplate.id}"
    version = "$Latest"
  }
  health_check_grace_period = 150
  health_check_type = "EC2"
  default_cooldown = 300
  tag {
    key                 = "Name"
    value               = "Ghost Website ASG"
    propagate_at_launch = true
  }
  target_group_arns = ["${aws_lb_target_group.ghost-target-group.arn}"]
}

# Create Application LoadBalancer
resource "aws_lb" "external-ghost-alb" {
  name               = "ExternalGhostALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb-sg.id}"]
  subnets            = ["${aws_subnet.public-subnet-a.id}", "${aws_subnet.public-subnet-b.id}"]
}


# Create ALB Listener
resource "aws_lb_listener" "ghost_listener" {
  load_balancer_arn = "${aws_lb.external-ghost-alb.arn}"
   port              = 80
  protocol          = "HTTP"
  # port              = "443"
  # protocol          = "HTTPS"
#  certificate_arn   = aws_acm_certificate.cert.arn


  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ghost-target-group.arn}"
  }
  # depends_on = [time_sleep.wait]
}

#Create Application LoadBalancer Target Group
resource "aws_lb_target_group" "ghost-target-group" {
  name     = "ALB-Ghost-TG"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.ghostvpc.id}"
  health_check {
  healthy_threshold = 5
  matcher = 200
  path = "/"
  }
  deregistration_delay = 10
}
