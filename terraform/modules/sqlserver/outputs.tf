output "sqlserver_endpoint" {
  description = "RDS SQL Server endpoint"
  value       = aws_db_instance.sqlserver.address
}

output "sqlserver_port" {
  description = "RDS SQL Server port"
  value       = aws_db_instance.sqlserver.port
}

output "sqlserver_identifier" {
  description = "RDS SQL Server identifier"
  value       = aws_db_instance.sqlserver.id
}

output "sqlserver_security_group_id" {
  description = "Security group attached to SQL Server"
  value       = aws_security_group.sqlserver.id
}
