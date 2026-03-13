# Migration Roadmap: Monolith to AWS Microservices

## Phase 0: Foundations (Week 1-2)

1. Establish repository standards
- Add service folder convention: `src/services/<service-name>/...`.
- Add Dockerfile per service and centralized `docker-compose.yml`.
- Add GitVersion semantic strategy.

2. Provision AWS baseline with Terraform
- VPC, subnets, ALB, ECS cluster, ECR repos, IAM, CloudWatch.
- Dev and prod environment directories.

3. Set up CI/CD
- Pull request CI checks.
- Dev auto-deploy from `develop` branch.
- Prod deployment from Git tags or manual approval.

## Phase 1: Strangler Pattern Start (Week 3-5)

1. Extract `auth-service` and `patient-service` first.
2. Keep monolith routing for remaining endpoints.
3. Route extracted paths via API gateway to new services.
4. Introduce service-level schema ownership and migrations.

## Phase 2: Core Clinical Extraction (Week 6-10)

1. Extract `doctor-service` and `appointment-service`.
2. Move appointment conflict logic into dedicated service.
3. Publish/consume domain events for scheduling and notifications.

## Phase 3: Supporting Domains (Week 11-14)

1. Extract `medical-records-service`, `department-service`, `staff-service`.
2. Add `notification-service` consumers for reminders and alerts.
3. Decommission equivalent monolith modules.

## Phase 4: Hardening and Optimization (Week 15+)

1. Reliability
- Autoscaling policies.
- Health checks, circuit breakers, retries, idempotency.

2. Security
- WAF in front of ALB.
- KMS encryption and secret rotation.
- Least privilege IAM and environment isolation.

3. Data strategy
- Complete database per service where practical.
- CDC/event-driven synchronization for read models.

## Delivery Gates per service

- API contract approved.
- Data contract and migration script reviewed.
- Docker image builds with GitVersion tags.
- Terraform deployment successful in dev.
- Load and security smoke tests pass.
- Rollback procedure tested.

## Risks and Mitigations

1. Tight coupling in legacy schema
- Mitigation: schema ownership and anti-corruption layer during transition.

2. Breaking API clients
- Mitigation: gateway-level backward compatibility and endpoint versioning.

3. Operational complexity
- Mitigation: standard templates, centralized observability, runbooks.
