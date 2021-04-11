$wabbaJackLocation = '\Wabbajack';

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
$settingsToBackup = @(
'~/AppData/Local/JetBrains/Toolbox/.settings',
'~/AppData/Local/JetBrains/Toolbox/.settings.json',
'~/AppData/Roaming/terminus/config.yaml'
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
    (Get-Content .\installedPSModules.txt) | Where-Object { $_.trim() -ne "" } | Set-Content .\installedPSModules.txt

    Write-Output 'A' | yarn global upgrade
    $installedYarnPackagesFile = '.\installedYarnPackages.txt'
    $installedPackages = yarn global list
    Out-File $installedYarnPackagesFile
    ForEach ($line in $($installedPackages -split "`r`n"))
    {
        if ($line -match 'info')
        {
            $line | Select-String -Pattern "\b(?!info|has|binaries|\d|\d\d\b)[a-zA-Z-]+" -AllMatches | ForEach-Object {
                Add-Content $installedYarnPackagesFile $_.matches.value.toString()
            }
        }
    }

    choco upgrade all -y --skip-virus-check
    choco list -l -r --id-only | Out-File .\installedChocoPackages.txt

    $wslPassword = (Select-String -Path .env -Pattern 'wslPassword=').ToString().Split('=')[1];
    $wslUpdateCommand = "echo " + $wslPassword + " | sudo -S apt update && sudo apt upgrade -y && sudo apt autoremove"
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

function backupSettings
{
    foreach ($setting in $settingsToBackup)
    {
        Copy-Item $setting ./settingsBackup
    }

    Get-ChildItem './settingsBackup' | Format-Table Name -HideTableHeaders | Out-File './backedUpSettings.txt'
    (Get-Content './backedUpSettings.txt') | Where-Object { $_.trim() -ne "" } | Set-Content './backedUpSettings.txt'
}

function cleanup
{
    Get-Process Wabbajack | Stop-Process

    # Delete old versions of Wabbajack
    Set-Location $wabbaJackLocation

    Remove-Item logs -Recurse -Force

    $numberOfVersions = (Get-ChildItem -Path . -Directory).Count
    if ($numberOfVersions -gt 1)
    {
        Get-ChildItem . -Directory | Sort-Object LastWriteTime | Select-Object -First ($numberOfVersions - 1) | Remove-Item -Recurse -Force
    }

    # Delete desktop shortcuts
    Remove-Item "C:\Users\*\Desktop\*.lnk" -Force

    # Stop Docker containers and remove images
    docker stop $(docker ps -a -q) -f
    docker rm $(docker ps -a -q) -f
    docker rmi $(docker images -a -q) -f

    # Update this repo (Ex. to update installedChocoPackages
    Set-Location $PSScriptRoot
    $commitMessage = [System.Text.StringBuilder]::new()
    $commitMessage.Append('Automatic update: ');
    $date = Get-Date -Format u
    $commitMessage.Append($date)

    git add .
    git commit -m $commitMessage.ToString()

    if ($?)
    {
        git push
    }
    else
    {
        Add-Content -Path .\theGraph.txt 'The GitHub contribution graph is a lie.'
        git add .
        git commit -m $commitMessage.ToString()
        git push
    }
}

function openLinksArray($links)
{
    foreach ($link in $links)
    {
        Start-Process Chrome $link
    }
}

function morningRoutine
{
    update
    openLinks
    Start-Process 'privateFunctions/openExtraLinks.ps1' -Wait
    backupSettings
    cleanup
    Set-Location ~/
}

morningRoutine
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
