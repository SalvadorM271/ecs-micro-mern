//creates ecs cluster
resource "aws_ecs_cluster" "main_ecs_cluster" {
  name = "${var.name}-cluster-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Environment = var.environment
  }
}

//creates log group
resource "aws_cloudwatch_log_group" "main_lgr" {
  name = "${var.name}-ecs-lgr-${var.environment}"

  tags = {
    Environment = var.environment
  }
}