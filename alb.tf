module "load_balancer" {
    source = "./modules/alb"
    // load balancer
    alb_name = "${var.name}-alb-${var.environment}"
    environment = var.environment
    alb_security_groups = [aws_security_group.alb-sg]
    public_subnets = [module.public_subnet_1.mySubnet, module.public_subnet_2.mySubnet]
    // load balancer target group
    alb_tg_name = "${var.name}-tg-lb-${var.environment}"
    alb_tg_port = var.alb_tg_port
    vpc_id = aws_vpc.main.id
    alb_tg_matcher = var.alb_tg_matcher
    alb_tg_path = var.alb_tg_path
    // https listener
    alb_tls_cert_arn = var.alb_tls_cert_arn 
}