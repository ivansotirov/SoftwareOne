output "vpc_id" {
  value = aws_vpc.this.id
}

output "pub_subnet1_id" {
  value = aws_subnet.public_az1.id
}

output "pub_subnet2_id" {
  value = aws_subnet.public_az2.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_az1.id
}

output "private_subnet2_id" {
  value = aws_subnet.private_az2.id
}

output "private_subnet_data1_id" {
  value = aws_subnet.private_data_az1.id
}

output "private_subnet_data2_id" {
  value = aws_subnet.private_data_az2.id
}
