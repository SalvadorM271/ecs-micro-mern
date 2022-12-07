// load balancer
variable alb_name {}
variable environment {}
variable alb_security_groups {}
variable public_subnets {}
// load balancer target group
variable alb_tg_name {}
variable alb_tg_port {}
variable vpc_id {}
variable alb_tg_matcher {}
variable alb_tg_path {}
// https listener
variable alb_tls_cert_arn {}