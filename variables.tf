variable region {
    default = "us-east-2"
}
variable environment {}
variable name {}

// vpc
variable cidr {}

// subnets
variable subnet_cidr_block {}
variable availability_zone {}
variable map_public_ip_on_launch {}

// load balancer
// load balancer target group
variable alb_tg_port {}
variable alb_tg_matcher {}
variable alb_tg_path {}
// https listener
variable alb_tls_cert_arn {}


// task definition
variable container_cpu {}
variable container_memory {}
variable client_container_image {}
variable client_container_port {}
variable client_container_host_port {}
variable client_log_driver {}
variable hello_container_image {}
variable hello_log_driver {}


// service
variable service_desired_count {}
variable deployment_minimum_healthy_percent {}
variable deployment_maximum_percent {}
variable health_check_grace_period_seconds {}

// cloud map
variable ttl_sd {}
variable record_type {}
variable routing_policy {}
variable failure_threshold {}