locals {
  instance_type      = var.instance_type
  vpc_id             = var.vpc_id
  private_subnet1_id = var.private_subnet1_id
  private_subnet2_id = var.private_subnet2_id
}

# Create Security Group for the Web Server
resource "aws_security_group" "this" {
  name        = "Web Server SG"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB SG"
  vpc_id      = local.vpc_id
  ingress {
    description     = "ALB Access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${var.sgr_alb}"]
  }
  ingress {
    description = "EFS Access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web Server SG"
  }
}

resource "aws_efs_file_system" "this" {
  creation_token = "efs"
}

resource "aws_efs_mount_target" "this1" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = local.private_subnet1_id
}

resource "aws_efs_mount_target" "this2" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = local.private_subnet2_id
}

data "template_file" "init" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    efs-dns = "${aws_efs_file_system.this.dns_name}"
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "MyWebServer"
  image_id             = var.ami_id
  instance_type        = local.instance_type
  security_groups      = [aws_security_group.this.id]
  user_data            = data.template_file.init.rendered
  iam_instance_profile = aws_iam_instance_profile.this.arn
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = "AutoScalingGroup"
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = ["${local.private_subnet1_id}", "${local.private_subnet2_id}"]
  target_group_arns    = ["${var.tgr_alb_arn}"]
  health_check_type    = "ELB"
  min_size             = 2
  max_size             = 2
}

resource "aws_iam_instance_profile" "this" {
  name = "test_profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "test-ssm-role"
  description        = "The role for the management of resources EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
}
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
