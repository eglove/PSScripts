Write-Host 'Running Microsoft Update...'
Get-WindowsUpdate -MicrosoftUpdate
Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate