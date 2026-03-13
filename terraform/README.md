# Terraform IaC for AWS Microservices Platform

## What this provisions

- VPC with public/private subnets.
- Internet gateway and NAT for private egress.
- ALB with path-based routing.
- ECS Fargate cluster.
- ECR repositories (one per service).
- CloudWatch log groups.
- ECS task definitions and services for all microservices.

## Folder Layout

- `infra/terraform/modules/platform`: reusable platform module.
- `infra/terraform/environments/dev`: development stack.
- `infra/terraform/environments/prod`: production stack.

## Usage

### Dev

```bash
cd infra/terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Prod

```bash
cd infra/terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Remote State Recommendation

Use an S3 backend with DynamoDB locking (configure in each environment before first apply).

Example backend block to add in `versions.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "hospital-mgmt/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

## Deployment Flow

- GitHub Actions builds and pushes service images to ECR.
- Terraform deploys ECS services using `image_tag` from GitVersion.
- ALB routes API path prefixes to the matching service.

## Notes

- Add HTTPS listener and ACM certificate for production traffic.
- Integrate AWS Secrets Manager for service secrets and DB credentials.
- Add WAF and autoscaling policies for production hardening.
