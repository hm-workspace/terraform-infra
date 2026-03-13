param(
    [string]$WorkspaceName = "hm-workspace",
    [string]$RootPath = "C:\Manoj\Projects\Personal\HospitalManagement\service-repos"
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Join-Path $RootPath $WorkspaceName
$base = Join-Path $workspaceRoot "services"
New-Item -ItemType Directory -Force -Path $base | Out-Null

$services = @(
    @{ Repo = "hm-api-gateway"; Project = "ApiGatewayService"; Port = 8080 },
    @{ Repo = "hm-auth-service"; Project = "AuthService"; Port = 8081 },
    @{ Repo = "hm-patient-service"; Project = "PatientService"; Port = 8082 },
    @{ Repo = "hm-doctor-service"; Project = "DoctorService"; Port = 8083 },
    @{ Repo = "hm-appointment-service"; Project = "AppointmentService"; Port = 8084 },
    @{ Repo = "hm-medical-records-service"; Project = "MedicalRecordsService"; Port = 8085 },
    @{ Repo = "hm-department-service"; Project = "DepartmentService"; Port = 8086 },
    @{ Repo = "hm-staff-service"; Project = "StaffService"; Port = 8087 },
    @{ Repo = "hm-notification-service"; Project = "NotificationService"; Port = 8088 }
)

foreach ($svc in $services) {
    $repoPath = Join-Path $base $svc.Repo
    $slnName = "$($svc.Project).sln"
    $apiProjName = "$($svc.Project).Api"
    $apiProjPath = Join-Path $repoPath "src\$apiProjName"

    New-Item -ItemType Directory -Force -Path $repoPath | Out-Null

    Push-Location $repoPath

    if (-not (Test-Path (Join-Path $repoPath ".git"))) {
        git init | Out-Null
    }

    if (-not (Test-Path (Join-Path $repoPath $slnName))) {
        dotnet new sln -n $svc.Project | Out-Null
    }

    if (-not (Test-Path (Join-Path $apiProjPath "$apiProjName.csproj"))) {
        dotnet new webapi -n $apiProjName -o "src/$apiProjName" --framework net8.0 --use-controllers --no-restore | Out-Null
        dotnet sln add "src/$apiProjName/$apiProjName.csproj" | Out-Null
    }

    $dockerfile = @"
# syntax=docker/dockerfile:1.7
ARG DOTNET_VERSION=8.0

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} AS build
WORKDIR /src
COPY . .
RUN dotnet restore "src/$apiProjName/$apiProjName.csproj"
RUN dotnet publish "src/$apiProjName/$apiProjName.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION} AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "$apiProjName.dll"]
"@
    Set-Content -Path (Join-Path $repoPath "Dockerfile") -Value $dockerfile -Encoding UTF8

    $gitignore = @"
bin/
obj/
.vs/
*.user
*.suo
*.swp
*.log
.env
"@
    Set-Content -Path (Join-Path $repoPath ".gitignore") -Value $gitignore -Encoding UTF8

    $readme = @"
# $($svc.Repo)

Independent microservice repository for Hospital Management.

## Local run

```bash
dotnet restore
dotnet build
dotnet run --project src/$apiProjName/$apiProjName.csproj
```

## Docker

```bash
docker build -t $($svc.Repo):local .
docker run -p $($svc.Port):8080 $($svc.Repo):local
```

## GitHub setup later

```bash
git branch -M main
git remote add origin <your-github-repo-url>
git add .
git commit -m "Initial scaffold"
git push -u origin main
```
"@
    Set-Content -Path (Join-Path $repoPath "README.md") -Value $readme -Encoding UTF8

    Pop-Location
}

Write-Host "Created service repos in: $base"
Get-ChildItem -Directory $base | Select-Object Name | Format-Table -AutoSize
