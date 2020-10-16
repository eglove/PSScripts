[String[]]$psModules =
'PSWindowsUpdate'

[String[]]$yarnGlobals =
'mrm'

[String[]]$chocoPackages =
'0ad',
'anki',
'autoclicker',
'balabolka',
'everything',
'f.lux',
'foxitreader',
'geforce-experience',
'geforce-game-ready-driver',
'gh',
'git',
'google-backup-and-sync',
'GoogleChrome',
'imagemagick',
'jetbrainstoolbox',
'jbs',
'microsoft-teams',
'microsoft-windows-terminal',
'minecraft-launcher',
'nodejs',
'notepadplusplus',
'obs-studio',
'ojdkbuild',
'picpick.portable',
'powershell-core',
'speccy',
'steam',
'terminus',
'twitch',
'vim',
'vlc',
'vortex',
'vscode',
'yarn'

function displayStep {
    Write-Host $args[0] -ForegroundColor Red -BackgroundColor White
}

# Chocolatey Pro install
displayStep 'Installing Chocolatey...'
Set-ExecutionPolicy Unrestricted # Temporary, will end set to AllSigned at end
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv
New-Item $env:ChocolateyInstall\license -Type Directory -Force
Copy-Item $PSScriptRoot\chocolatey.license.xml $env:ChocolateyInstall\license\chocolatey.license.xml -Force
choco feature enable -n allowGlobalConfirmation
choco upgrade chocolatey.extension
refreshenv

# WSL2 Install
displayStep 'Installing WSL2...'
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
choco install wsl2
Set-Location $env:USERPROFILE\Downloads
curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output wslUpdate.msi
Start-Process wslUpdate.msi -Wait
Remove-Item wslUpdate.msi
Start-Process powershell -Wait {
    wsl --set-default-version 2;
    choco install wsl-ubuntu-2004;
}
$ubuntuExe = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter ubuntu2004.exe -Recurse
Start-Process $ubuntuExe -Wait

# Install everything else
displayStep 'Installing Software...'
choco install $chocoPackages --skip-virus-check
displayStep 'Installing Yarn Globals...'
Start-Process powershell -Wait {
    yarn global add $yarnGlobals;
}
displayStep 'Installing Powershell Modules...'
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Package $psModules
refreshenv

# Grab PSScripts from GH, set environment variable
displayStep 'Cloning Powershell Scripts...'
Set-Location C:\
Start-Process powershell -Wait {
    gh auth login;
    gh repo clone eglove/PSScripts;
}
$env:Path = $env:Path,"C:\PSScripts" -join ";"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)

# Update windows
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll

# Remove desktop shortcuts (includes recycle bin)
Remove-Item "C:\Users\*\Desktop\*.*" -Force

# Change Windows settings via registry
function setSettings {
    foreach($setting in $args[0]) {
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name $setting -Value $args[1]
    }
}
$advancedSettingsEnable = @('TaskbarSmallIcons', 'TaskbarGlomLevel', 'MMTaskbarEnabled', 'MMTaskbarGlomLevel')
$advancedSettingsDisable = @('ShowCortanaButton', 'HideFileExt')
setSettings $advancedSettingsEnable 1
setSettings $advancedSettingsDisable 0
# Not an 'advanced' setting
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0
Stop-Process -Name "Explorer"

# Set Intellij Toolbox settings (will generate new idea script, auto updates for ides)
Copy-Item $PSScriptRoot\.settings $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings -Force
Copy-Item $PSScriptRoot\.settings.json $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings.json -Force

# Set execuation policy away from unrestricted
Set-ExecutionPolicy AllSigned

# Open clean disk tool to safely remove Windows.old
cleanmgr /d C

#Delete original script from downloads
Set-Location $env:USERPROFILE\Downloads
Remove-Item script.ps1
