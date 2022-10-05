variable "instance_type" {
  description = "Type of the EC2 instance class"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "private_subnet1_id" {
  description = "Private Subnet1 id"
}

variable "private_subnet2_id" {
  description = "Private Subnet2 id"
}

variable "sgr_alb" {
  description = "Security Group of the ALB"
}

variable "ami_id" {
  description = "AMI id"
}

variable "tgr_alb_arn" {
  description = "Target Group ARN of the ALB"
}
