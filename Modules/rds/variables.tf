variable "db_subnet1" {
  description = "Private Subnet1 Data Id"
}

variable "db_subnet2" {
  description = "Private Subnet2 Data Id"
}

variable "vpc_id" {
  type        = string
  description = "The Id of the VPC"
}

variable "ec2_sg" {
  description = "Ec2 SG to connect to RDS"
}

variable "db_size" {
  description = "DB size - storage amount"
}

variable "db_name" {
  description = "DB schema name"
}

variable "db_instance_type" {
  description = "DB instance type - for e.g. t2.micro"
}
