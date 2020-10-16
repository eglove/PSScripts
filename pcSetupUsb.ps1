# Download and run pcSetup script from https://github.com/eglove/PSScripts/blob/master/pcSetup.ps1
Set-Location $env:USERPROFILE\Downloads
Start-BitsTransfer -Source https://raw.githubusercontent.com/eglove/PSScripts/master/pcSetup.ps1 -Destination script.ps1
Start-Process script.ps1