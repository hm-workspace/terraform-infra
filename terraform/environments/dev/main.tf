module "platform" {
  source = "../../modules/platform"

  project_name = var.project_name
  environment  = "dev"
  aws_region   = var.aws_region
  image_tag    = var.image_tag

  vpc_cidr             = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs = ["10.20.11.0/24", "10.20.12.0/24"]

  services = {
    "api-gateway" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/api/*"
      health_check_path = "/health"
    }
    "portal" = {
      container_port    = 80
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/*"
      health_check_path = "/health"
    }
    "auth-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/api/auth*"
      health_check_path = "/health"
    }
    "patient-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 512
      memory            = 1024
      path_pattern      = "/api/patients*"
      health_check_path = "/health"
    }
    "doctor-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 512
      memory            = 1024
      path_pattern      = "/api/doctors*"
      health_check_path = "/health"
    }
    "appointment-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 512
      memory            = 1024
      path_pattern      = "/api/appointments*"
      health_check_path = "/health"
    }
    "medical-records-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 512
      memory            = 1024
      path_pattern      = "/api/medical-records*"
      health_check_path = "/health"
    }
    "department-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/api/departments*"
      health_check_path = "/health"
    }
    "staff-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/api/staff*"
      health_check_path = "/health"
    }
    "notification-service" = {
      container_port    = 8080
      desired_count     = 1
      cpu               = 256
      memory            = 512
      path_pattern      = "/api/notifications*"
      health_check_path = "/health"
    }
  }

  tags = {
    Owner       = "platform-team"
    Application = "hospital-management"
  }
}

output "alb_dns_name" {
  value = module.platform.alb_dns_name
}

output "ecr_repository_urls" {
  value = module.platform.ecr_repository_urls
}

output "vpc_id" {
  value = module.platform.vpc_id
}

output "private_subnet_ids" {
  value = module.platform.private_subnet_ids
}
