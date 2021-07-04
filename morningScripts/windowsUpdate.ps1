Write-Host 'Running Windows Update...'
Get-WindowsUpdate -WindowsUpdate
Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate