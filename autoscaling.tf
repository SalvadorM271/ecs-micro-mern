// ----------------------------------- scaling for client service ----------------------------------------

// creates a target to a service so it can be scaled
resource "aws_appautoscaling_target" "client_ecs_target_scaling" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main_ecs_cluster.name}/${aws_ecs_service.client.name}" // targeted service
  scalable_dimension = "ecs:service:DesiredCount" // onlyone available at the moment
  service_namespace  = "ecs"
}

// policy to scale based on memory
resource "aws_appautoscaling_policy" "ecs_policy_memory_client" {
  name               = "${var.name}-mem-client-pol-${var.environment}"
  policy_type        = "TargetTrackingScaling" // adjusts the capacity of your scalable resource as needed to maintain your target value
  // target for this policy
  resource_id        = aws_appautoscaling_target.client_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.client_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.client_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization" //type of metric taken in this case memory
    }

    target_value       = "70" // The policy will add or remove capacity as required to keep the metric as close to this target as possible
    scale_in_cooldown  = "300"   // time to pass btw autoscalings in and out
    scale_out_cooldown = "300"
  }
}

// policy to scale based on cpu
resource "aws_appautoscaling_policy" "ecs_policy_cpu_client" {
  name               = "${var.name}-cpu-client-pol-${var.environment}"
  policy_type        = "TargetTrackingScaling" // adjusts the capacity of your scalable resource as needed to maintain your target value
  // target for this policy
  resource_id        = aws_appautoscaling_target.client_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.client_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.client_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = "70" // The policy will add or remove capacity as required to keep the metric as close to this target as possible
    scale_in_cooldown  = "300" // time to pass btw autoscalings in and out
    scale_out_cooldown = "300"
  }
}

// ----------------------------------- scaling for backend service ----------------------------------------

// creates a target to a service so it can be scaled
resource "aws_appautoscaling_target" "backend_ecs_target_scaling" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main_ecs_cluster.name}/${aws_ecs_service.backend.name}" // targeted service
  scalable_dimension = "ecs:service:DesiredCount" // onlyone available at the moment
  service_namespace  = "ecs"
}

// policy to scale based on memory
resource "aws_appautoscaling_policy" "ecs_policy_memory_backend" {
  name               = "${var.name}-mem-backend-pol-${var.environment}"
  policy_type        = "TargetTrackingScaling" // adjusts the capacity of your scalable resource as needed to maintain your target value
  // target for this policy
  resource_id        = aws_appautoscaling_target.backend_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization" //type of metric taken in this case memory
    }

    target_value       = "70" // The policy will add or remove capacity as required to keep the metric as close to this target as possible
    scale_in_cooldown  = "300"   // time to pass btw autoscalings in and out
    scale_out_cooldown = "300"
  }
}

// policy to scale based on cpu
resource "aws_appautoscaling_policy" "ecs_policy_cpu_backend" {
  name               = "${var.name}-cpu-backend-pol-${var.environment}"
  policy_type        = "TargetTrackingScaling" // adjusts the capacity of your scalable resource as needed to maintain your target value
  // target for this policy
  resource_id        = aws_appautoscaling_target.backend_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.backend_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = "70" // The policy will add or remove capacity as required to keep the metric as close to this target as possible
    scale_in_cooldown  = "300" // time to pass btw autoscalings in and out
    scale_out_cooldown = "300"
  }
}