variable "environment_name" {
  type        = string
  default     = ""
  description = "Name of your enviorment, keep the value in lower case"
}
variable "app_name" {
  type    = string
  default = ""

}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet1_id" {
  description = "ID of your two Publicsubnets"
  type        = string
  default     = ""
}
variable "subnet2_id" {
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
variable "redis_nodes_number_tf" {
  type        = number
  default     = 1
  description = "Number of node for your redis cluster"
}
variable "redis_port" {
  type        = number
  default     = 6379
  description = "Redis cluster port"
}

variable "cluster_mode_enabled_tf" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}
variable "cluster_size_tf" {
  type        = number
  default     = 1
  description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
}
variable "cluster_mode_num_node_groups_tf" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}
variable "cluster_mode_replicas_per_node_group_tf" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}
variable "automatic_failover_enabled_tf" {
  type        = bool
  default     = false
  description = "Automatic failover (Not available for T1/T2 instances)"
}
variable "snapshot_retention_limit_tf" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}

