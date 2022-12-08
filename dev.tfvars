region = "us-east-2"
environment = "dev"
name = "ecs-microservice"

//vpc
cidr = "10.0.0.0/16"
//subnets
subnet_cidr_block = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
availability_zone = ["us-east-2a", "us-east-2b"]
map_public_ip_on_launch = [true, false]

// load balancer
// load balancer target group
alb_tg_port = "80"//same as client
alb_tg_matcher = "200"
alb_tg_path = "/"
// https listener
alb_tls_cert_arn = "arn:aws:acm:us-east-2:153042419275:certificate/e76d59d6-fd3a-4085-9d91-cd33d27640c6"

//task definition
container_cpu = "0.5 vCPU"
container_memory = "1GB"
client_container_image = "153042419275.dkr.ecr.us-east-2.amazonaws.com/frontend"
client_container_port = "80"
client_container_host_port = "80" //has to be the same bc network mode
client_log_driver = "awslogs"
hello_container_image = "153042419275.dkr.ecr.us-east-2.amazonaws.com/backend"
hello_log_driver = "awslogs"


//service
service_desired_count = "1"
deployment_minimum_healthy_percent = "0" //needs to be 0 so i can reset my service
deployment_maximum_percent = "200"
health_check_grace_period_seconds = "60"

// cloud map
ttl_sd = "30"
record_type = "A"
routing_policy = "MULTIVALUE"
failure_threshold = "3"