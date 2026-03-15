variable "aws_region" {
  type        = string
  description = "AWS region for deployment."
}

variable "project_name" {
  type        = string
  description = "Project naming prefix."
  default     = "hospital-mgmt"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where SQL Server will be created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DB subnet group."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDRs allowed to connect to SQL Server."
  default     = []
}

variable "db_username" {
  type        = string
  description = "Master username."
  default     = "adminuser"
}

variable "db_password" {
  type        = string
  description = "Master password."
  sensitive   = true
}

variable "engine" {
  type        = string
  description = "RDS SQL Server edition."
  default     = "sqlserver-se"
}

variable "engine_version" {
  type        = string
  description = "RDS SQL Server engine version."
  default     = null
  nullable    = true
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.m5.large"
}

variable "allocated_storage" {
  type        = number
  description = "Storage in GB."
  default     = 100
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment."
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention in days."
  default     = 14
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection."
  default     = true
}
