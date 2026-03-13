# Deployment Guide: AWS + Terraform + Docker + GitHub Actions

## Prerequisites

1. AWS account with OIDC trust for GitHub Actions role.
2. Terraform state backend resources (S3 bucket + DynamoDB lock table).
3. Service source projects added under `src/services/...` as referenced by Dockerfiles.

## GitHub Repository Variables

- `AWS_REGION` (example: `ap-south-1`)

## GitHub Repository Secrets

- `AWS_DEPLOY_ROLE_ARN`
- `TF_STATE_BUCKET`
- `TF_LOCK_TABLE`

## Branching and Release Flow

1. Feature branches -> PR -> `CI` workflow validation.
2. Merge to `develop` -> `Deploy Dev` workflow.
3. Create release tag `vX.Y.Z` on `main` -> `Deploy Prod` workflow.

## Versioning Details

GitVersion configuration is in `GitVersion.yml`.

Docker tags pushed per service:
- `<semVer>` (example `1.2.3-beta.4` on develop)
- `<majorMinorPatch>`
- `sha-<commit-sha>`
- `dev-latest` for develop

## First-Time Infrastructure Deployment

1. Apply dev stack manually once:

```bash
cd infra/terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply -var-file=terraform.tfvars
```

2. Apply prod stack manually once:

```bash
cd infra/terraform/environments/prod
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply -var-file=terraform.tfvars
```

3. Verify outputs:
- ALB DNS name
- ECR repository URLs

## Runtime Configuration

Add service environment variables using one of:
- ECS task definition `environment` entries (non-sensitive)
- AWS Secrets Manager + task role access (sensitive)

## Recommended Hardening

1. Add HTTPS listener and ACM certificate.
2. Add WAF rules and IP reputation filtering.
3. Add ECS autoscaling policies per service.
4. Add CloudWatch alarms and on-call notifications.
