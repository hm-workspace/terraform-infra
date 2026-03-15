resource "aws_db_subnet_group" "sqlserver" {
  name       = "${var.project_name}-${var.environment}-sqlserver-subnets"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-sqlserver-subnets"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "sqlserver" {
  name        = "${var.project_name}-${var.environment}-sqlserver-sg"
  description = "Allow MSSQL access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      description = "MSSQL from allowed CIDR"
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sqlserver-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_db_instance" "sqlserver" {
  identifier                 = "${var.project_name}-${var.environment}-sqlserver"
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  storage_type               = "gp3"
  username                   = var.db_username
  password                   = var.db_password
  port                       = 1433
  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = false
  copy_tags_to_snapshot      = true
  publicly_accessible        = false
  vpc_security_group_ids     = [aws_security_group.sqlserver.id]
  db_subnet_group_name       = aws_db_subnet_group.sqlserver.name
  auto_minor_version_upgrade = true
  apply_immediately          = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-sqlserver"
    Environment = var.environment
    Project     = var.project_name
  }
}
