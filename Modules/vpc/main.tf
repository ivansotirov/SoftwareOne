locals {
  vpc_cidr                  = var.vpc_cidr
  dns_support               = var.dns_support
  dns_host_names            = var.dns_host_names
  vpc_name                  = var.vpc_name
  public_subnet1_cidr       = var.public_subnet1_cidr
  public_subnet2_cidr       = var.public_subnet2_cidr
  private_subnet1_cidr      = var.private_subnet1_cidr
  private_subnet2_cidr      = var.private_subnet2_cidr
  private_subnet_data1_cidr = var.private_subnet_data1_cidr
  private_subnet_data2_cidr = var.private_subnet_data2_cidr

}

resource "aws_vpc" "this" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = local.dns_support
  enable_dns_hostnames = local.dns_host_names
  tags = {
    key                 = "Name"
    value               = "${local.vpc_name}"
    propagate_at_launch = true
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "igate-${local.vpc_name}"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name = "natgw-${local.vpc_name}"
  }
}

resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "eip-natgw-${local.vpc_name}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_az1" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet1_cidr
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_az1-${local.vpc_name}"
  }
}

resource "aws_subnet" "public_az2" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet2_cidr
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_az2-${local.vpc_name}"
  }
}

resource "aws_subnet" "private_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet1_cidr
  tags = {
    "Name" = "private_az1-${local.vpc_name}"
  }
}

resource "aws_subnet" "private_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet2_cidr
  tags = {
    "Name" = "private_az2-${local.vpc_name}"
  }
}

resource "aws_subnet" "private_data_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet_data1_cidr
  tags = {
    "Name" = "private_data_az1-${local.vpc_name}"
  }
}

resource "aws_subnet" "private_data_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet_data2_cidr
  tags = {
    "Name" = "private_data_az2-${local.vpc_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_data_az1" {
  subnet_id      = aws_subnet.private_data_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_data_az2" {
  subnet_id      = aws_subnet.private_data_az2.id
  route_table_id = aws_route_table.private.id
}
