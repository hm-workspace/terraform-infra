param(
    [Parameter(Mandatory = $true)]
    [string]$GitHubOwner,

    [string]$WorkspaceName = "hm-workspace",

    [string]$RootPath = "C:\Manoj\Projects\Personal\HospitalManagement\service-repos",

    [switch]$Push
)

$ErrorActionPreference = "Stop"

$WorkspaceRoot = Join-Path $RootPath $WorkspaceName

$repoMap = @(
    @{ Name = "hm-api-gateway"; Folder = "services" },
    @{ Name = "hm-auth-service"; Folder = "services" },
    @{ Name = "hm-patient-service"; Folder = "services" },
    @{ Name = "hm-doctor-service"; Folder = "services" },
    @{ Name = "hm-appointment-service"; Folder = "services" },
    @{ Name = "hm-medical-records-service"; Folder = "services" },
    @{ Name = "hm-department-service"; Folder = "services" },
    @{ Name = "hm-staff-service"; Folder = "services" },
    @{ Name = "hm-notification-service"; Folder = "services" },
    @{ Name = "customer-portal"; Folder = "ui" },
    @{ Name = "admin-portal"; Folder = "ui" },
    @{ Name = "terraform-infra"; Folder = "platform" }
)

foreach ($entry in $repoMap) {
    $repoName = $entry.Name
    $repoPath = Join-Path (Join-Path $WorkspaceRoot $entry.Folder) $repoName
    if (-not (Test-Path $repoPath)) {
        Write-Warning "Skipping missing repo: $repoPath"
        continue
    }

    Push-Location $repoPath

    if (-not (Test-Path ".git")) {
        git init | Out-Null
    }

    git branch -M main | Out-Null

    $remoteUrl = "https://github.com/$GitHubOwner/$repoName.git"
    $hasOrigin = (git remote) -contains "origin"

    if (-not $hasOrigin) {
        git remote add origin $remoteUrl
    }
    else {
        git remote set-url origin $remoteUrl
    }

    git add .
    $hasChanges = git status --porcelain
    if (-not [string]::IsNullOrWhiteSpace($hasChanges)) {
        git commit -m "Initial scaffold" | Out-Null
    }

    if ($Push) {
        git push -u origin main
        Write-Host "Pushed: $repoName -> $remoteUrl"
    }
    else {
        Write-Host "Prepared: $repoName -> $remoteUrl (use -Push to push)"
    }

    Pop-Location
}

Write-Host "Done."
