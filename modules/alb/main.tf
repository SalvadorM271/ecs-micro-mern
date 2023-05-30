resource "aws_lb" "main_lb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups.*.id
  subnets            = var.public_subnets.*.id

  enable_deletion_protection = "false"

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "main_gr" {
  name        = var.alb_tg_name
  port        = var.alb_tg_port //needs to be the port of my client
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" //needs to be ip otherwise wont work try instance bc the ip is no static

  health_check {
    protocol            = "HTTP"
    matcher             = var.alb_tg_matcher
    path                = var.alb_tg_path
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_lb.main_lb]
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.id
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #       target_group_arn = aws_alb_target_group.main_gr.id
  #       type             = "forward"
  #   }

  # if you need tou use http uncomment the default action above, and comment everything below

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect traffic to target group
resource "aws_alb_listener" "https" {
    load_balancer_arn = aws_lb.main_lb.id
    port              = "443"
    protocol          = "HTTPS"

    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.alb_tls_cert_arn //needs to be check  arn:aws:acm:us-east-2:153042419275:certificate/e76d59d6-fd3a-4085-9d91-cd33d27640c6

    default_action {
        target_group_arn = aws_alb_target_group.main_gr.id
        type             = "forward"
    }
}