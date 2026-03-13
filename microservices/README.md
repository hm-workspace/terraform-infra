# Hospital Management Microservices Blueprint

This repository currently contains architecture and API documentation for a hospital platform. This blueprint converts the documented monolith/domain model into a deployable AWS microservices platform.

## Current State (from available docs)

- Rich domain model with 27 entities (users, roles, patients, doctors, appointments, departments, staff, records).
- Monolithic API structure with layered architecture (API, Service, Data, InternalModals).
- Azure-oriented deployment notes.
- No source projects are present in this workspace, so this conversion provides production-ready platform scaffolding and migration design.

## Target State

- Domain-oriented microservices on AWS ECS Fargate.
- Infrastructure managed with Terraform.
- Per-service Docker images with semantic versioning from GitVersion.
- GitHub Actions CI/CD for image build/push and environment deployments.

## Service Decomposition

1. `api-gateway`
- Entry point for web/mobile clients.
- Request routing, auth enforcement, rate limiting, API aggregation.

2. `auth-service`
- Identity, JWT, refresh tokens, password reset, role claims.
- Owns users/roles authentication logic.

3. `patient-service`
- Patient profile, allergies, vitals, emergency contacts, insurance summary pointers.

4. `doctor-service`
- Doctor profile, qualifications, availability, ratings.

5. `appointment-service`
- Scheduling, conflict checks, lifecycle status, symptoms/prescriptions linkage.

6. `medical-records-service`
- Patient medical history and longitudinal records.

7. `department-service`
- Departments, locations, services, contact info.

8. `staff-service`
- Staff profile, shift schedule, staff type lookup.

9. `notification-service`
- Email/SMS/push for reminders and workflow events.

## AWS Target Platform

- Compute: ECS Fargate services behind Application Load Balancer.
- Container Registry: Amazon ECR (one repository per service).
- Network: VPC with public and private subnets.
- Data: Start with a shared SQL Server database, then carve out service databases incrementally.
- Secrets: AWS Secrets Manager / SSM Parameter Store.
- Observability: CloudWatch logs and metrics.

## Versioning Standard

Docker tags are generated with GitVersion (`gitversion.net` style semantic versioning):

- `major.minor.patch` (example `2.4.1`)
- `major.minor` (example `2.4`)
- commit SHA (example `sha-a1b2c3d`)
- environment convenience tag (example `dev-latest`)

See `GitVersion.yml` and GitHub workflows for implementation.

## Included in this conversion

- `docker/` per-service Dockerfiles.
- `docker-compose.yml` for local service orchestration.
- `infra/terraform/` AWS IaC for ECS platform and service deployment.
- `.github/workflows/` CI and deployment automation.
- `microservices/MIGRATION_ROADMAP.md` phased migration strategy.
- `microservices/SERVICE_BOUNDARIES.md` ownership and API boundaries.

## Important Note

Because source code projects are not present in this workspace, Dockerfiles and pipelines are wired as templates with explicit `PROJECT_PATH` and `APP_DLL` build arguments. Once service projects are added in `src/services/...`, the pipelines become executable with minimal changes.
