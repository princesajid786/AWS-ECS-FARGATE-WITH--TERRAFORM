variable "environment_name" {
    default = ""
}
variable "vpc_id" {
    default = ""
  }
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
variable "db_pass" {
  default = ""
}
variable "db_port" {
  default = ""
}
variable "rds_sg" {
    default = ""
}
variable "masterdbidentifier"{
    default = ""
}
variable "rdssubnetgroup" {
    default = "" 
}
variable "create" {
    default = false 
}
