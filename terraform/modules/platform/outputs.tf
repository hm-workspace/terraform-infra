output "alb_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = aws_lb.this.dns_name
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "ecr_repository_urls" {
  description = "ECR repository URLs by service name."
  value = {
    for service_name in sort(keys(var.services)) :
    service_name => "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${service_name}"
  }
}
