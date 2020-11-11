Write-Host 'Updating Windows...'
Get-WindowsUpdate
Install-WindowsUpdate -AutoReboot -AcceptAll
Write-Host 'Updating Powershell Modules...'
Update-Module -AcceptLicense
Write-Host 'Updating Global Yarn Packages...'
yarn global upgrade
Write-Host 'Updating Software...'
choco upgrade all
Write-Host 'Complete!'
Start-Process 'C:\Program Files\Anki\anki.exe'
Start-Process 'https://docs.google.com/spreadsheets/d/16K1DybdEvhb3ng0mtlp02sd3M9aukLXB9fzKE9oCXKk/edit#gid=0'
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
