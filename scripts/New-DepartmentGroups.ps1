# New-DepartmentGroups.ps1
# Creates a security group SG-<department> in each department OU if it does not already exist.
# Note: -WhatIf is still set, so this is a dry run and creates nothing.

$ou = "HR", "IT", "Finance", "Sales"
foreach ($o in $ou) {
    $exists = Get-ADGroup -Filter "Name -eq 'SG-$o'"
    if (-not $exists) { 
        Write-Host "SG-$o missing, creating it now"
        New-ADGroup -Name "SG-$o" -GroupCategory Security -GroupScope Global -Path "OU=$o,DC=homelab,DC=local" -WhatIf 
    }
    else {
        Write-Host "SG-$o already exists, skipping creation"
    }
}