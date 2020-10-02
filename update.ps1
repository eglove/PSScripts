Write-Host 'Updating Windows...'
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll
Write-Host 'Updating Powershell Modules...'
Update-Module -AcceptLicense
Write-Host 'Updating Global Yarn Packages...'
yarn global upgrade
Write-Host 'Updating Software...'
choco upgrade all
Write-Host 'Complete!'
Start-Process 'C:\Program Files\Anki\anki.exe'
