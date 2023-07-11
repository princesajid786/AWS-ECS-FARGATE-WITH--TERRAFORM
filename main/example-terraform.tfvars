project = 
environment = 
ecr_repo_name = 
region = 
core_stack_name = 
namespaces = ["", ""]








variable "namespaces" {
  description = "List of service discovery namespaces for ECS services. Creates a default namespace"
  type        = list(string)
  default     = ["", ""]
}

variable "first_container_image" {
  description = "Ecr image for frontend task definition"
  default     = ""

}
variable "second_container_image" {
  description = "Ecr image for backend task definition"
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
# database_username changed
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

