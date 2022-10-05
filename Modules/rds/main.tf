locals {
  db_engine = "mysql"
}

resource "aws_db_subnet_group" "this" {
  subnet_ids = [var.db_subnet1, var.db_subnet2]
}

resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  name   = "SGR-${local.db_engine}"
  ingress {
    description     = "mysql security group allow traffic from ec2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${var.ec2_sg}"]
    # ingress = [{
    #   description      = "mysql security group allow traffic from ec2"
    #   from_port        = 3306
    #   to_port          = 3306
    #   protocol         = "tcp"
    #   security_groups  = ["${var.ec2_sg}"]
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   security_groups  = []
    #   self             = false
    #   cidr_blocks      = []

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # egress = [{
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   description      = "allow all outbound traffic"
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   ipv6_cidr_blocks = []
  #   prefix_list_ids  = []
  #   security_groups  = []
  #   self             = false
  # }]
}

resource "aws_db_instance" "this" {
  allocated_storage      = var.db_size
  db_name                = var.db_name
  engine                 = local.db_engine
  engine_version         = "5.7"
  instance_class         = var.db_instance_type
  username               = "root"
  password               = random_password.this.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  db_subnet_group_name   = aws_db_subnet_group.this.name
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "this" {
  name  = "/test/database/password/master"
  type  = "SecureString"
  value = random_password.this.result
}



