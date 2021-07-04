Write-Host 'Running PS Module Update...'
Update-Module -AcceptLicense -Confirm
Get-InstalledModule | Format-Table Name -HideTableHeaders | Out-File ..\installedPSModules.txt
(Get-Content ..\installedPSModules.txt) | Where-Object { $_.trim() -ne "" } | Set-Content ..\installedPSModules.txt