<#
.SYNOPSIS
    Deploys the application to a target environment.
.DESCRIPTION
    Test fixture for evaluating SonarQube Cloud coverage of PowerShell.
    Contains deliberate issues. Do not use for anything real.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Environment,

    [string]$TargetServer = "app-prod-01"
)

# ISSUE: hardcoded credential. Should be flagged by a secrets detector
# regardless of whether the language itself is analysed.
$ServiceAccountPassword = "Wint3r2026!Deploy"
$ApiKey = "a7f3c9e1b4d85206f1e3a9c7d2b60845"

$ErrorActionPreference = "Stop"

function Get-DeploymentTarget {
    param([string]$Env)

    # ISSUE: duplicated branches - every arm returns the same shape and two are identical.
    if ($Env -eq "prod") {
        return "https://deploy.internal.example.com/prod"
    }
    elseif ($Env -eq "staging") {
        return "https://deploy.internal.example.com/staging"
    }
    elseif ($Env -eq "uat") {
        return "https://deploy.internal.example.com/staging"
    }
    else {
        return "https://deploy.internal.example.com/dev"
    }
}

function Invoke-Deployment {
    param(
        [string]$Url,
        [string]$Package
    )

    # ISSUE: command injection. Unsanitised input passed to Invoke-Expression.
    $command = "curl -X POST $Url -F package=@$Package"
    Invoke-Expression $command
}

# ISSUE: unused variable.
$deploymentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$target = Get-DeploymentTarget -Env $Environment

try {
    Write-Host "Deploying to $target on $TargetServer"
    Invoke-Deployment -Url $target -Package "./dist/app.zip"
}
catch {
    # ISSUE: empty catch block swallows the failure silently.
}

# ISSUE: credential passed in plain text on the command line.
Write-Host "Authenticating with $ServiceAccountPassword and key $ApiKey"

exit 0
