output "sgr_alb" {
  value = aws_security_group.this.id
}

output "tgr_alb_arn" {
  value = aws_lb_target_group.this.arn
}

output "aws_lb" {
  value = aws_lb.this.dns_name
}
