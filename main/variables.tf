variable "project" {
  default     = ""
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = ""

}
variable "ecr_repo_name" {
  description = "The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, periods and forward slashes e.g test-123"
  type = string
  default = "" 
  validation {
     condition = can(regexall("^[a-z]+[0-9a-z./_-]+$", var.ecr_repo_name))
     error_message = "Repository name must start with a letter and can only contain lowercase letters"
   } 
}
variable "region" {
  default     = ""
  type        = string
  description = "AWS Region"
}
variable "core_stack_name" {
  description = "The name of Core Infrastructure stack."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "CIDR block for VPC"
  type        = string
  default     = ""
}
variable "subnets" {
  type    = list(any)
  default = []
}

variable "namespaces" {
  description = "List of service discovery namespaces for ECS services. Creates a default namespace"
  type        = list(string)
  default     = [""]
}

variable "first_container_image" {
  description = "Image tag, e.g account_id.dkr.ecr.region.amazonaws.com/repositoryname:imagetag"
  default     = ""

}
variable "second_container_image" {
  description = "Image tag, e.g account_id.dkr.ecr.region.amazonaws.com/repositoryname:imagetag"
  default     = ""

}
/////rds
variable "subnet1_id" {
  default = ""
}
variable "subnet2_id" {
  default = ""
}
variable "db_allocated_storage" {
  default = ""
}
variable "db_engine" {
  default = ""
}
variable "db_username" {
  default = ""
}
variable "db_instance_class" {
  default = ""
}
variable "db_name" {
  default = ""
}
variable "db_port" {
  default = ""
}
variable "rds_sg" {
  default = ""
}
variable "masterdbidentifier" {
  default = ""
}
variable "rdssubnetgroup" {
  default = ""
}
//////redis
variable "environment_name" {
  type        = string
  default     = ""
  description = "Name of your enviorment, keep the value in lower case"
  validation {
     condition = can(regexall("[a-z]", var.environment_name))
     error_message = "The environment name must be lower cases"
   }
}
variable "app_name" {
  type    = string
  default = ""
}
variable "redis_instance_type_tf" {
  type        = string
  default     = ""
  description = "Instance type of your Redis cache"
}
variable "redis_engine_tf" {
  type        = string
  default     = ""
  description = "Engine of your Redis cache"
}

