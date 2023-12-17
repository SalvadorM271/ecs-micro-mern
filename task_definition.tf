// client task definition

resource "aws_ecs_task_definition" "client" {
  family                   = "${var.name}-client-task-${var.environment}" //task name
  network_mode             = "awsvpc" // the only network mode that works with fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // special rol for using ecs
  task_role_arn            = aws_iam_role.ecs_ssm_role.arn // this rol is for the task to be able to interact with ssm
  container_definitions = jsonencode([{
    name        = "${var.name}-client-task-${var.environment}"
    image       = var.client_container_image
    // this determines wheather on not it would be restore on crash
    essential   = true
    // env variables that can be pass to the container
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    // only client would need port mapping on this use case, since only client is connected to alb
    portMappings = [{
      protocol      = "tcp"
      containerPort = tonumber(var.client_container_port) //--------------------- only one uses this
      hostPort      = tonumber(var.client_container_host_port)
    }]
    logConfiguration = {
      logDriver = var.client_log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

// backend microservice task definition

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.name}-backend-task-${var.environment}" //task name
  network_mode             = "awsvpc" // the only network mode that works with fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // special rol for using ecs
  task_role_arn            = aws_iam_role.ecs_ssm_role.arn // this rol is for the task to be able to interact with ssm
  container_definitions = jsonencode([{
    name        = "${var.name}-backend-task-${var.environment}"
    image       = var.backend_container_image
    // this determines wheather on not it would be restore on crash
    essential   = true
    // env variables that can be pass to the container
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    // no port needed since it connects to the client trouhg internal network
    portMappings = [{
      protocol      = "tcp"
      containerPort = tonumber(var.server_container_port) //--------------------- only one uses this
      hostPort      = tonumber(var.server_container_host_port)
    }]
    logConfiguration = {
      logDriver = var.hello_log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}





