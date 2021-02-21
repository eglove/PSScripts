# REQUIRES on same USB & file location.
# chocolatey.license.xml
# Download and run pcSetup script from https://github.com/eglove/PSScripts/blob/master/pcSetup.ps1
Start-BitsTransfer -Source https://raw.githubusercontent.com/eglove/PSScripts/master/pcSetup.ps1 -Destination script.ps1
Invoke-Expression '.\script.ps1'
