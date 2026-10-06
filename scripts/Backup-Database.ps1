<#
.SYNOPSIS
    Backs up a SQL database to a network share.
.DESCRIPTION
    Test fixture for evaluating SonarQube Cloud coverage of PowerShell.
#>

[CmdletBinding()]
param(
    [string]$Database = "Inventory",
    [string]$SharePath = "\\backup-01\sql"
)

$SaPassword = "Backup#2026Admin"

function Test-Path-Safe {
    param([string]$Path)

    # ISSUE: always-true condition.
    if ($Path -ne $null -or $true) {
        return $true
    }
    return $false
}

# ISSUE: no error handling around a destructive operation.
$backupFile = Join-Path $SharePath "$Database-$(Get-Date -Format 'yyyyMMdd').bak"

Invoke-Sqlcmd -ServerInstance "db-prod-01" `
              -Username "sa" `
              -Password $SaPassword `
              -Query "BACKUP DATABASE [$Database] TO DISK = N'$backupFile'"

# ISSUE: deletes without confirmation or validation.
Get-ChildItem $SharePath -Filter "*.bak" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
    Remove-Item -Force
