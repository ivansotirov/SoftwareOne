variable "vpc_cidr" {
  description = "This is the CIDR range for the VPC to be created"
}

variable "dns_support" {
  type        = bool
  description = "Do you want to enable DNS support for the VPC"
}

variable "dns_host_names" {
  type        = bool
  description = "Do you want to enable resolving of DNS host names for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The Name of the VPC"
}

variable "public_subnet1_cidr" {
  description = "Public Subnet1 CIDR range"
}

variable "public_subnet2_cidr" {
  description = "Public Subnet2 CIDR range"
}

variable "private_subnet1_cidr" {
  description = "Private Subnet1 CIDR range"
}

variable "private_subnet2_cidr" {
  description = "Private Subnet2 CIDR range"
}

variable "private_subnet_data1_cidr" {
  description = "Private Subnet1 Data CIDR range"
}

variable "private_subnet_data2_cidr" {
  description = "Private Subnet2 Data CIDR range"
}
