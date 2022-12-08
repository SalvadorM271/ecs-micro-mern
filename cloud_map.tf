// service discovery ----------------------------------- already edited

resource "aws_service_discovery_private_dns_namespace" "micro" {
  name        = "corp"
  description = "mern stack service"
  vpc         = aws_vpc.main.id
}


resource "aws_service_discovery_service" "hello" {
  name = "hello"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.micro.id

    dns_records {
      ttl  = var.ttl_sd
      type = var.record_type
    }

    routing_policy = var.routing_policy
  }

  health_check_custom_config {
    failure_threshold = var.failure_threshold
  }
}

resource "aws_service_discovery_service" "client" {
  name = "client"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.micro.id

    dns_records {
      ttl  = var.ttl_sd
      type = var.record_type
    }

    routing_policy = var.routing_policy
  }

  health_check_custom_config {
    failure_threshold = var.failure_threshold
  }
}


