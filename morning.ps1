function update
{
    Write-Host 'Updating...'
    Get-WindowsUpdate -WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate
    Get-WindowsUpdate -MicrosoftUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate
    Update-Module -AcceptLicense -Confirm
    yarn global upgrade
    choco upgrade all -y --skip-virus-check
    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait

    # Update Wabbajack
    Set-Location 'C:\Wabbajack'
    Start-Process 'C:\Wabbajack\Wabbajack.exe'
    # Delete old version of Wabbajack
    if ((Get-ChildItem -Path . -Directory).Count -gt 1)
    {
        Get-ChildItem . -Directory | Sort-Object LastWriteTime | Select-Object -First 1 | Remove-Item -Recurse -Force
    }
}

function openLinks
{
    Start-Process 'C:\Program Files\Anki\anki.exe'

    Set-Location $PSScriptRoot/privateFunctions
    $today = Get-Date
    if ( $today.DayOfWeek.ToString().Equals("Saturday"))
    {
        ./openFinanceLinks
    }

    ./openMorningLinks

    Set-Location ~/
}

function morningRoutine
{
    update
    openLinks
}

morningRoutine
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
