
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-${var.environment}-vpc"
  cidr = ""

  azs             = ["", "", ""]
  private_subnets = ["", ""]
  public_subnets  = ["", ""]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "stg"
  }
}

resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = var.ecr_repo_name
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

module "core-infra" {
  source          = "../modules/core-infra"
  core_stack_name = var.core_stack_name
  aws_region      = var.region
  namespaces      = var.namespaces
  enable_nat_gw   = var.enable_nat_gw
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  frontend_image  = var.frontend_image
  backend_image   = var.backend_image
}

module "rds" {
  source               = "../modules/rds"
  environment_name     = var.environment
  rdssubnetgroup       = var.rdssubnetgroup
  vpc_id               = module.vpc.vpc_id
  subnet1_id           = module.vpc.private_subnets[0]
  subnet2_id           = module.vpc.private_subnets[1]
  masterdbidentifier   = var.masterdbidentifier
  rds_sg               = var.rds_sg
  db_allocated_storage = var.db_allocated_storage
  db_engine         = var.db_engine
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_port           = var.db_port
}

module "redis" {
  source                 = "../modules/redis"
  environment_name       = var.environment
  app_name               = var.app_name
  redis_instance_type_tf = var.redis_instance_type_tf
  redis_engine_tf        = var.redis_engine_tf
  vpc_id                 = module.vpc.vpc_id
  subnet1_id             = module.vpc.private_subnets[0]
  subnet2_id             = module.vpc.private_subnets[1]
}
