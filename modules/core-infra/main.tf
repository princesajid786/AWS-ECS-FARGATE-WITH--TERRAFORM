
locals {
  name = var.core_stack_name
  env  = var.env_name
  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-ecs-blueprints"
  }
  task_execution_role_managed_policy_arn = ["arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
  "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

################################################################################
# ECS Blueprint
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 4.0"

  cluster_name = local.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.this.name
      }
    }
  }

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
        base   = 1
      }
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7

  tags = local.tags
}

################################################################################
# Service discovery namespaces
################################################################################

resource "aws_service_discovery_private_dns_namespace" "sd_namespaces" {
  for_each = toset(var.namespaces)

  name        = "${each.key}.${module.ecs.cluster_name}.local"
  description = "service discovery namespace.clustername.local"
  vpc         = var.vpc_id
}

################################################################################
# Task Execution Role
################################################################################

resource "aws_iam_role" "execution" {
  name               = "${local.name}-${local.env}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.execution.json
  # managed_policy_arns = local.task_execution_role_managed_policy_arn
  tags = local.tags
}

data "aws_iam_policy_document" "execution" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy_attachment" "execution" {
  count      = length(local.task_execution_role_managed_policy_arn)
  name       = "${local.name}-${local.env}-execution-policy"
  roles      = [aws_iam_role.execution.name]
  policy_arn = local.task_execution_role_managed_policy_arn[count.index]
}
resource "aws_ssm_parameter" "ecs_cluster-id" {
  name        = "/${local.env}/ecs/clusterid"
  description = "The parameter description"
  type        = "String"
  value       = module.ecs.cluster_id

  tags = {
    environment = local.env
  }
}
resource "aws_security_group" "ecs-lb-sg" {
  name        = "Load_Balancer_Sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = var.second_container_port
    to_port     = var.second_container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = var.second_container_port
    to_port     = var.second_container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.env
  }
}
resource "aws_lb" "fr_lb" {
  name               = "${local.env}-fr-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.ecs-lb-sg.id]

}
resource "aws_lb_target_group" "fr_lb_target_group" {
  name        = "frontend-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-499"
    timeout             = "15"
    path                = "/"
    unhealthy_threshold = "5"
  }
}

resource "aws_lb_listener" "fr_lb_listener" {
  load_balancer_arn = aws_lb.fr_lb.arn
  port              = "80"
  protocol          = "HTTP"
  #certificate_arn = aws_acm_certificate.cert_alb[0].arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fr_lb_target_group.arn
  }
}
resource "aws_lb" "back_lb" {
  name               = "${local.env}-backend-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.ecs-lb-sg.id]

}
resource "aws_lb_target_group" "back_lb_target_group" {
  name        = "backend-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "back_lb_listener" {
  load_balancer_arn = aws_lb.back_lb.arn
  port              = "80"
  protocol          = "HTTP"
  #certificate_arn = aws_acm_certificate.cert_alb[0].arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back_lb_target_group.arn
  }
}
resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.first_container_name}-service"
  cpu                      = 256
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn

  container_definitions = jsonencode([
    {
      name      = var.first_container_name
      image     = var.first_container_image
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.first_container_port
          hostPort      = var.first_container_port
        }
      ]
    }
  ])

}
resource "aws_ecs_service" "frontend" {
  name            = var.first_container_name
  cluster         = module.ecs.cluster_name
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs-lb-sg.id]
    assign_public_ip = true

  }
  load_balancer {
    target_group_arn = aws_lb_target_group.fr_lb_target_group.arn
    container_name   = var.first_container_name
    container_port   = var.first_container_port
  }
}
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.second_container_name}-service"
  cpu                      = 256
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution.arn

  container_definitions = jsonencode([
    {
      name      = var.second_container_name
      image     = var.second_container_image
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.second_container_port
          hostPort      = var.second_container_port
        }
      ]
    }
  ])

}
resource "aws_ecs_service" "backend" {
  name            = var.second_container_name
  cluster         = module.ecs.cluster_name
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs-lb-sg.id]
    assign_public_ip = true

  }
  load_balancer {
    target_group_arn = aws_lb_target_group.back_lb_target_group.arn
    container_name   = var.second_container_name
    container_port   = var.second_container_port
  }

}
