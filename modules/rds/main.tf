# Generate a random password
resource "random_password" "db_password" {
  length  = 10
  special = false
}

# Create a Database Subnet Group
resource "aws_db_subnet_group" "DatabaseSubnetGroup" {
  name       = "${var.environment_name}-${var.rdssubnetgroup}"
  subnet_ids = [var.subnet1_id, var.subnet2_id]

  tags = {
    Name = "${var.environment_name}-${var.rdssubnetgroup}-subnetgroup"
  }
}

resource "aws_db_instance" "Master" {
  instance_class          = var.db_instance_class
  identifier              = "${var.environment_name}-${var.masterdbidentifier}"
  name                    = var.db_name
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  username                = var.db_username
  password                = random_password.db_password.result
  db_subnet_group_name    = aws_db_subnet_group.DatabaseSubnetGroup.name
  vpc_security_group_ids  = [aws_security_group.RdsSecurityGroup.id]
  skip_final_snapshot     = true
  backup_retention_period = 5
  tags = {
    Name = "${var.environment_name}-${var.masterdbidentifier}"
  }
}
resource "aws_db_instance" "replica_master" {
  count                   = var.create ? 1 : 0
  replicate_source_db     = aws_db_instance.Master.identifier
  identifier              = "${var.environment_name}-${var.masterdbidentifier}-replica"
  instance_class          = var.db_instance_class
  allocated_storage       = 5
  backup_retention_period = 0
  skip_final_snapshot     = true
  tags = {
    Name = "${var.environment_name}-${var.masterdbidentifier}-replica"
  }
}
# Create a Rds Security Group
resource "aws_security_group" "RdsSecurityGroup" {
  vpc_id = var.vpc_id
  name   = "${var.environment_name}-${var.rds_sg}"
  ingress {
    from_port   = var.db_port
    protocol    = "tcp"
    to_port     = var.db_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment_name}-${var.rds_sg}"
  }
}

resource "aws_secretsmanager_secret" "rds_staging_password" {
  name = "db-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.rds_staging_password.id
  secret_string = random_password.db_password.result
}
