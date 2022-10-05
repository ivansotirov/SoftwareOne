locals {
  vpc_id         = var.vpc_id
  public_subnet1 = var.public_subnet1_id
  public_subnet2 = var.public_subnet2_id
}

# Create Security Group for the ALB
resource "aws_security_group" "this" {
  name        = "ALB SG"
  description = "Enable HTTP access on Port 80 for Clients"
  vpc_id      = local.vpc_id
  ingress {
    description = "Client Access"
    from_port   = 80
    to_port     = 80
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
    Name = "ALB SG"
  }
}

resource "aws_lb" "this" {
  name               = "testLoadBalancer"
  load_balancer_type = "application"
  subnets            = ["${local.public_subnet1}", "${local.public_subnet2}"]
  security_groups    = [aws_security_group.this.id]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = "LBtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

###Alarms
resource "aws_sns_topic" "this" {
}

resource "aws_sns_topic_subscription" "this" {
  protocol  = "email"
  topic_arn = aws_sns_topic.this.arn
  endpoint  = "ivansotirov@abv.bg"
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "High Number of Request - above 2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 2
  evaluation_periods  = 1
  metric_name         = "RequestCount"
  statistic           = "Sum"
  period              = 60
  namespace           = "AWS/ApplicationELB"
  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
    TargetGroup  = aws_lb_target_group.this.arn_suffix
  }
  alarm_actions      = [aws_sns_topic.this.arn]
  ok_actions         = [aws_sns_topic.this.arn]
  treat_missing_data = "notBreaching"
}
