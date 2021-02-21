﻿$wabbaJackLocation = '\Wabbajack';

$morningLinks = @(
    'https://hangouts.google.com/?authuser=1',
    'https://mail.google.com/mail/u/1/#inbox'
);
$financeLinks = @(
    'https://www.glassdoor.com/knowyourworth/dashboard.htm',
    'https://www.paypal.com/',
    'https://smile.amazon.com/gp/css/order-history?ie=UTF8&ref_=nav_youraccount_orders&',
    'https://docs.google.com/spreadsheets/d/1NRRzw3Ok7my5xRIG6AKKoBadOK3Sca4ZoMg2vhKHxoA/edit',
    'https://thevillagesgg.securecafe.com/residentservices/villages-at-general-grant/payments.aspx#tab_MakePayments',
    'https://www.ameren.com/',
    'https://www.chase.com/',
    'https://www.usaa.com/inet/ent_logon/Logon?redirectjsp=true',
    'https://www.lightstream.com/account',
    'https://www.wealthfront.com/',
    'https://www.lendingclub.com/',
    'https://app.youneedabudget.com/'
);

function update
{
    # Update Wabbajack
    Set-Location $wabbaJackLocation
    Start-Process Wabbajack

    Write-Host 'Running Windows Update...'
    Set-Location $PSScriptRoot
    Get-WindowsUpdate -WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate

    Write-Host 'Running Microsoft Update...'
    Get-WindowsUpdate -MicrosoftUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate

    Write-Host 'Running PS Module Update...'
    Update-Module -AcceptLicense -Confirm
    Get-InstalledModule | Format-Table Name -HideTableHeaders | Out-File .\installedPSModules.txt
    (Get-Content .\installedPSModules.txt) | Where-Object {$_.trim() -ne "" } | Set-Content .\installedPSModules.txt

    yarn global upgrade

    choco upgrade all -y --skip-virus-check
    choco list -l -r --id-only | Out-File .\installedChocoPackages.txt

    $wslPassword = (Select-String -Path .env -Pattern 'wslPassword=').ToString().Split('=')[1];
    $wslUpdateCommand = "echo "+$wslPassword+" | sudo -S apt update && sudo apt upgrade -y && sudo apt autoremove"
    Start-Process wsl -ArgumentList $wslUpdateCommand -Wait
}

function openLinks
{
    Start-Process '\Program Files\Anki\anki.exe'

    $today = Get-Date
    if ( $today.DayOfWeek.ToString().Equals("Saturday"))
    {
        openLinksArray($financeLinks)
    }

    openLinksArray($morningLinks)
}

function cleanup
{
    # Delete old versions of Wabbajack
    Set-Location $wabbaJackLocation
    $numberOfVersions = (Get-ChildItem -Path . -Directory).Count
    if ($numberOfVersions -gt 1)
    {
        Get-ChildItem . -Directory | Sort-Object LastWriteTime | Select-Object -First ($numberOfVersions - 1) | Remove-Item -Recurse -Force
    }

    Get-Process Wabbajack | Stop-Process

    # Delete desktop shortcuts
    Remove-Item "C:\Users\*\Desktop\*.lnk" -Force

    # Update this repo (Ex. to update installedChocoPackages
    Set-Location $PSScriptRoot
    Add-Content -Path .\theGraph.txt 'The GitHub contribution graph is a lie.'
    $commitMessage = [System.Text.StringBuilder]::new()
    $commitMessage.Append('Automatic update: ');
    $date = Get-Date -Format u
    $commitMessage.Append($date)

    git add .
    git commit -m $commitMessage.ToString()
    git push
}

function openLinksArray($links)
{
    foreach($link in $links) {
        Start-Process Chrome $link
    }
}

function morningRoutine
{
    update
    openLinks
    cleanup
    Set-Location ~/
}

morningRoutine
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
