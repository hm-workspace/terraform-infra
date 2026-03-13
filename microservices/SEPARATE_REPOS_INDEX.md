# Separate Service Repositories Index

Service repositories are scaffolded under the HM workspace root at:

`C:\Manoj\Projects\Personal\HospitalManagement\service-repos\hm-workspace\services`

## Repositories

- `hm-api-gateway`
- `hm-auth-service`
- `hm-patient-service`
- `hm-doctor-service`
- `hm-appointment-service`
- `hm-medical-records-service`
- `hm-department-service`
- `hm-staff-service`
- `hm-notification-service`

Each repository includes:

- Independent git history (`.git` initialized)
- `.sln` solution
- ASP.NET Core Web API project in `src/<ProjectName>.Api`
- Service-level `Dockerfile`
- `.gitignore`
- `README.md`

## Why this keeps platform repo lightweight

- Application code is isolated in service repos.
- This platform repo can focus on shared assets: Terraform, architecture docs, platform workflows.
- Teams can release service repos independently.

## Next actions when you create GitHub repositories

For each service repo:

```bash
cd <service-repo-folder>
git branch -M main
git remote add origin <github-repo-url>
git add .
git commit -m "Initial scaffold"
git push -u origin main
```

You can automate these steps with `infra/scripts/push-service-repos.ps1`.
