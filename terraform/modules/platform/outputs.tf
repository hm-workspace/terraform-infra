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

output "vpc_id" {
  description = "VPC ID created for this environment."
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs created for this environment."
  value       = [for key in sort(keys(aws_subnet.private)) : aws_subnet.private[key].id]
}
