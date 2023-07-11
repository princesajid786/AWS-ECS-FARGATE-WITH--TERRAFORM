variable "core_stack_name" {
  description = "The name of Core Infrastructure stack."
  type        = string
  default     = "staging-infra"
}
variable "env_name" {
  description = "Name of the environment"
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

variable "enable_nat_gw" {
  description = "Provision a NAT Gateway in the VPC"
  type        = bool
  default     = false

}
variable "fr_lb_name" {
  description = "Name of first loadbalancer associated with first container"
  type        = string
  default     = ""
}
variable "second_lb_name" {
  description = "Name of second loadbalancer associated with second container"
  type        = string
  default     = ""
}
variable "first_container_image" {
  description = "Ecr image for task definition"
  type        = string
  default     = ""

}
variable "second_container_image" {
  description = "Ecr image for task definition"
  type        = string
  default     = ""

}
variable "first_container_name" {
  description = "Container name for first container"
  type        = string
  default     = ""
}
variable "second_container_name" {
  description = "Container name for second container"
  type        = string
  default     = ""
}
variable "first_container_port" {
  description = "Container port for first container"
  type        = string
  default     = ""
}
variable "second_container_port" {
  description = "Container port for second container"
  type        = string
  default     = ""
}
