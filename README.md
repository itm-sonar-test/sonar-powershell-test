# sonar-powershell-test

Test fixture for evaluating how SonarQube Cloud handles a repository written
entirely in PowerShell.

## What this is testing

1. **Is PowerShell an analysed language?** SonarQube Cloud supports roughly
   thirty languages. If PowerShell is not among them, no code quality rules
   should fire.

2. **Does Automatic Analysis consider the project eligible?** Automatic Analysis
   requires at least 20% of lines to be in a supported language. A pure
   PowerShell repository should fall below that threshold.

3. **Does the text and secrets sensor still fire?** That sensor scans files as
   text rather than as code, so hardcoded credentials may be detected even when
   the language itself is not analysed.

## Deliberate issues planted

All credentials in this repository are fictitious.

| File | Planted issue |
|------|---------------|
| `Deploy-App.ps1` | Hardcoded password and API key, command injection via `Invoke-Expression`, duplicated branches, unused variable, empty catch block |
| `Get-Inventory.ps1` | Connection string with embedded credentials, certificate validation disabled, unreachable code |
| `Backup-Database.ps1` | Hardcoded SA password, always-true condition, unguarded destructive delete |

No CI workflow is included on purpose — Automatic Analysis requires none, and
adding one would introduce YAML, which *is* an analysed language and would
contaminate the result.
