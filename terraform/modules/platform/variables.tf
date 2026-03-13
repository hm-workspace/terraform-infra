variable "project_name" {
  description = "Project short name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name, such as dev or prod."
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
}

variable "image_tag" {
  description = "Docker image tag deployed to all services for this rollout."
  type        = string
}

variable "services" {
  description = "Service catalog and ECS sizing/routing settings."
  type = map(object({
    container_port    = number
    desired_count     = number
    cpu               = number
    memory            = number
    path_pattern      = string
    health_check_path = string
  }))
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
