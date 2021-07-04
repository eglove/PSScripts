$wabbaJackLocation = '\Wabbajack';

# Update Wabbajack
Set-Location $wabbaJackLocation
Start-Process Wabbajack

Start-Sleep 60

Get-Process Wabbajack | Stop-Process

$numberOfVersions = (Get-ChildItem -Path . -Directory).Count
if ($numberOfVersions -gt 1)
{
    Get-ChildItem . -Directory | Sort-Object LastWriteTime | Select-Object -First ($numberOfVersions - 1) | Remove-Item -Recurse -Force
}