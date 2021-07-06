$scriptRoot = 'morningScripts/';

# Run first and use -Wait to allow these to restart system
$restartScripts = @(
'windowsUpdate',
'microsoftUpdate'
)

# Run in parallel
$nonRestartScripts = @(
'yarnUpdate',
'chocoUpdate',
'wabbajackUpdate',
'powershellModuleUpdate',
'ubuntuUpdate',
'cDocker',
'backupSettings',
'ankiUpdate',
'repoUpdate',
'openLinks'
)

Set-Location '\PSScripts'

foreach ($script in $restartScripts) {
    Start-Process $scriptRoot$script'.ps1' -Wait
}

foreach ($script in $nonRestartScripts) {
    Start-Process $scriptRoot$script'.ps1'
}

if (Test-Path logs)
{
    Remove-Item logs -Recurse -Force
}
Remove-Item "C:\Users\*\Desktop\*.lnk" -Force
Start-Process '\Program Files\Anki\anki.exe'
