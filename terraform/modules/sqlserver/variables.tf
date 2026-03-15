variable "project_name" {
  description = "Project prefix used for naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS should be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDRs allowed to connect to SQL Server"
  type        = list(string)
  default     = []
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true

  validation {
    condition = can(regex("^[!-~]{8,128}$", var.db_password)) && !can(regex("[\"/@]", var.db_password))
    error_message = "db_password must be 8-128 printable ASCII characters and cannot contain space, '/', '@', or '\"'."
  }
}

variable "engine" {
  description = "RDS SQL Server edition"
  type        = string
  default     = "sqlserver-ex"
}

variable "engine_version" {
  description = "RDS SQL Server engine version"
  type        = string
  default     = null
  nullable    = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.small"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 50
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the RDS SQL Server instance should be publicly accessible"
  type        = bool
  default     = false
}
