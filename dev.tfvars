region = "us-east-1"
environment = "dev"
name = "ecs-microservice"

//vpc
cidr = "10.0.0.0/16"
//subnets
subnet_cidr_block = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
availability_zone = ["us-east-1a", "us-east-1b"]
map_public_ip_on_launch = [true, false]

// load balancer
// load balancer target group
alb_tg_port = "80"//same as client
alb_tg_matcher = "200"
alb_tg_path = "/"
// https listener
alb_tls_cert_arn = "arn:aws:acm:us-east-1:438555236323:certificate/782198c5-e64d-4dbc-81c5-79e7bac59bcb"

//task definition
container_cpu = "0.5 vCPU"
container_memory = "1GB"
client_container_image = "438555236323.dkr.ecr.us-east-1.amazonaws.com/ecs_frontend"
client_container_port = "80"
client_container_host_port = "80" //has to be the same bc network mode
client_log_driver = "awslogs"
backend_container_image = "438555236323.dkr.ecr.us-east-1.amazonaws.com/ecs_backend"
hello_log_driver = "awslogs"
server_container_port = "5000"
server_container_host_port = "5000"


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