// creates rol for task definition

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-cluster-rol-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//attach policy needed for containers to work

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

//attach policy needed for cloud mapping

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment-2" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudMapFullAccess"
}

// rol for ssm

resource "aws_iam_role" "ecs_ssm_role" {
  name = "${var.name}-ssm-rol-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "allow_ssm" {
  name        = "allow_ssm"
  description = "Allows ssm to be use in the task"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-allow-ssm-role-policy-attachment" {
  role       = aws_iam_role.ecs_ssm_role.name
  policy_arn = aws_iam_policy.allow_ssm.arn
}