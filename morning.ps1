function update
{
    Write-Host 'Updating...'
    Get-WindowsUpdate -WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate
    Get-WindowsUpdate -MicrosoftUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate
    Update-Module -AcceptLicense -Confirm
    yarn global upgrade
    choco upgrade all
    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait

    # Update Wabbajack
    Set-Location 'C:\Wabbajack'
    Start-Process 'C:\Wabbajack\Wabbajack.exe'
}

function openLinks
{
    Start-Process 'C:\Program Files\Anki\anki.exe'
    Start-Process 'C:\Users\eglove\AppData\Local\Programs\Terminus\Terminus.exe'

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
