module "sqlserver" {
  source = "../../modules/sqlserver"

  project_name = var.project_name
  environment  = "prod"

  vpc_id              = var.vpc_id
  private_subnet_ids  = var.private_subnet_ids
  allowed_cidr_blocks = var.allowed_cidr_blocks

  db_username             = var.db_username
  db_password             = var.db_password
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
}

output "sqlserver_endpoint" {
  value = module.sqlserver.sqlserver_endpoint
}

output "sqlserver_port" {
  value = module.sqlserver.sqlserver_port
}

output "sqlserver_identifier" {
  value = module.sqlserver.sqlserver_identifier
}

output "sqlserver_security_group_id" {
  value = module.sqlserver.sqlserver_security_group_id
}
