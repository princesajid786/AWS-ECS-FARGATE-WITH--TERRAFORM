

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.environment_name}-${var.app_name}-subnet-group"
  subnet_ids = [var.subnet1_id,var.subnet2_id]
}
resource "aws_security_group" "redis_security_group" {
  vpc_id = var.vpc_id
  name   = "${var.environment_name}-${var.app_name}-redis"
  ingress {
    from_port       = 0
    protocol        = "tcp"
    to_port         = 65535
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.environment_name}-redis"
  }
}
resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id       = "${var.environment_name}-${var.app_name}-replica"
  description                = "${var.app_name}-${var.environment_name}-Redis replication group"
  node_type                  = var.redis_instance_type_tf
  num_cache_clusters         = var.cluster_mode_enabled_tf ? null : var.cluster_size_tf
  port                       = var.redis_port
  engine_version             = var.redis_engine_tf
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = [aws_security_group.redis_security_group.id]
  automatic_failover_enabled = var.cluster_mode_enabled_tf ? true : var.automatic_failover_enabled_tf
  num_node_groups            = var.cluster_mode_enabled_tf ? var.cluster_mode_num_node_groups_tf : null
  replicas_per_node_group    = var.cluster_mode_enabled_tf ? var.cluster_mode_replicas_per_node_group_tf : null
  snapshot_retention_limit   = var.snapshot_retention_limit_tf
}
