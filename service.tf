// service for client container

resource "aws_ecs_service" "client" {
  name                               = "${var.name}-client-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.client.arn
  desired_count                      = var.service_desired_count // how many container i need deploy in my case one for each zone (2)
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent // i need at least half of the container to work since im deploying in to av zones
  deployment_maximum_percent         = var.deployment_maximum_percent // if there is to much traffic i want a max of 4 
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds // how much time bf action is taken
  launch_type                        = "FARGATE" // what am i lauching ec2 or fargate
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id] // loop array and gets ids
    subnets          = [module.private_subnet_1.mySubnet.id, module.private_subnet_2.mySubnet.id] // there is more than one subnet so wildcard is use to take id for every subnet
    assign_public_ip = false // dont need to since i would be getting to this throuhg my alb
  }

  service_registries {
    registry_arn = aws_service_discovery_service.client.arn
  }

  load_balancer {
    target_group_arn = module.load_balancer.myAlbGr.arn
    container_name   = "${var.name}-client-task-${var.environment}" // name of the client container
    container_port   = var.client_container_port
  }

  # task difinition must be ignore otherwise terraform may overwrite our app deployments since they will be do outside of terraform
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}


// service for backend container

resource "aws_ecs_service" "backend" {
  name                               = "${var.name}-backend-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.backend.arn
  desired_count                      = var.service_desired_count // how many container i need deploy in my case one for each zone (2)
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent // i need at least half of the container to work since im deploying in to av zones
  deployment_maximum_percent         = var.deployment_maximum_percent // if there is to much traffic i want a max of 4 
  //health_check_grace_period_seconds  = var.health_check_grace_period_seconds // how much time bf action is taken
  launch_type                        = "FARGATE" // what am i lauching ec2 or fargate
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id] // loop array and gets ids
    subnets          = [module.private_subnet_1.mySubnet.id, module.private_subnet_2.mySubnet.id] // there is more than one subnet so wildcard is use to take id for every subnet
    assign_public_ip = false // dont need it for this one neither since im using cloud mapping to get it
  }

  //no load balancer for this one, instead we have service_registries

  service_registries {
    registry_arn = aws_service_discovery_service.backend.arn
  }

  # task difinition must be ignore otherwise terraform may overwrite our app deployments since they will be do outside of terraform
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

// service for world container

