$people = Import-Csv -Path "$PSScriptRoot\users.csv"

$password = Read-Host "Temporary password" -AsSecureString
foreach ($p in $people){ 
 $sam = "$($p.FirstName).$($p.LastName)".ToLower()
 $FullName = "$($p.FirstName) $($p.LastName)"
 $exists = Get-ADUser -Filter "SamAccountName -eq '$sam'"
 if (-not $exists) {
    Write-Host "$sam missing, creating"
    $params = @{
        Name = $FullName
        GivenName = $p.FirstName
        Surname = $p.LastName
        DisplayName = $FullName
        SamAccountName = $sam 
        UserPrincipalName = "$sam@homelab.local"
        Path = "OU=$($p.Department),DC=homelab,DC=local"
        AccountPassword = $password
        ChangePasswordAtLogon = $True 
        Enabled = $True
    }
    New-ADUser @params
    Add-ADGroupMember -Identity "SG-$($p.Department)" -Members $sam 
 } else {
    Write-host "$sam already exists"
 }
}