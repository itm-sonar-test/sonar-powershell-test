<#
.SYNOPSIS
    Collects a basic server inventory.
.DESCRIPTION
    Test fixture for evaluating SonarQube Cloud coverage of PowerShell.
#>

[CmdletBinding()]
param(
    [string[]]$ComputerName = @("app-prod-01", "app-prod-02", "db-prod-01")
)

# ISSUE: hardcoded connection string with embedded credentials.
$ConnectionString = "Server=db-prod-01;Database=Inventory;User Id=sa;Password=Sup3rSecret!;"

$results = @()

foreach ($computer in $ComputerName) {

    # ISSUE: insecure - certificate validation disabled.
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computer
    $cpu = Get-CimInstance -ClassName Win32_Processor -ComputerName $computer

    # ISSUE: string concatenation in a loop instead of a collection.
    $results += [PSCustomObject]@{
        Name    = $computer
        OS      = $os.Caption
        Memory  = $os.TotalVisibleMemorySize
        Cores   = $cpu.NumberOfCores
    }
}

# ISSUE: unreachable code after return.
function Write-Summary {
    param($Data)
    return $Data | Format-Table
    Write-Host "This line can never execute"
}

Write-Summary -Data $results
