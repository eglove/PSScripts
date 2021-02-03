function update
{
    Write-Host 'Updating...'

    # Update Wabbajack
    Set-Location '\Wabbajack'
    Start-Process Wabbajack

    Set-Location $PSScriptRoot
    Get-WindowsUpdate -WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate

    Get-WindowsUpdate -MicrosoftUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate

    Update-Module -AcceptLicense -Confirm

    yarn global upgrade

    choco upgrade all -y --skip-virus-check
    choco list -l -r --id-only | Out-File .\installedChocoPackages.txt

    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait
}

function openLinks
{
    Start-Process '\Program Files\Anki\anki.exe'

    Set-Location $PSScriptRoot/privateFunctions
    $today = Get-Date
    if ( $today.DayOfWeek.ToString().Equals("Saturday"))
    {
        ./openFinanceLinks
    }

    ./openMorningLinks

    Set-Location ~/
}

function cleanup
{
    # Delete old versions of Wabbajack
    $numberOfVersions = (Get-ChildItem -Path . -Directory).Count
    if ($numberOfVersions -gt 1)
    {
        Get-ChildItem . -Directory | Sort-Object LastWriteTime | Select-Object -First $numberOfVersions - 1 | Remove-Item -Recurse -Force
    }

    # Delete desktop shortcuts
    Remove-Item "C:\Users\*\Desktop\*.lnk" -Force

    # Update this repo (Ex. to update installedChocoPackages
    Set-Location $PSScriptRoot
    git add .
    git commit -m 'Updated Installed Packages'
    git push
}

function morningRoutine
{
    update
    openLinks
    cleanup
}

morningRoutine
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
