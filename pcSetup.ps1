# Save use drive name
$usbLocationObject = Get-Location
$usbLocation = $usbLocationObject.toString()

$psModules = @('PSWindowsUpdate')

$yarnGlobals = @('mrm')

$chocoPackages = @('0ad', 'anki', 'autoclicker', 'balabolka', 'everything', 'f.lux', 'foxitreader',
'geforce-experience', 'geforce-game-ready-driver', 'gh', 'git', 'google-backup-and-sync', 'GoogleChrome',
'imagemagick', 'jetbrainstoolbox', 'jbs', 'microsoft-teams', 'microsoft-windows-terminal', 'minecraft-launcher',
'nodejs', 'notepadplusplus', 'obs-studio', 'ojdkbuild', 'picpick.portable', 'powershell-core', 'speccy', 'steam',
'terminus', 'twitch', 'vim', 'vlc', 'vortex', 'vscode', 'yarn')

# Registry edits
$advancedSettingsEnable = @('TaskbarSmallIcons', 'TaskbarGlomLevel', 'MMTaskbarEnabled', 'MMTaskbarGlomLevel')
$advancedSettingsDisable = @('ShowCortanaButton', 'HideFileExt')

# Required WSL Linux Kernel, WSL2 and Ubuntu installed through chocolatey
Start-BitsTransfer -Source 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi' -Destination 'wslUpdate.msi'
$wslUpdate = Get-ChildItem 'wslUpdate.msi'

# External files only on USB
$chocoLicense = $usbLocation'chocolatey.license.xml'
$jetbrainsSettings = $usbLocation'.settings'
$jetbrainsSettingsJson = $usbLocation'.settings.json'

# Temporary, will set to AllSigned at end
Set-ExecutionPolicy Unrestricted;
# Set Security Protocol to TLS 1.2, required for chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;

function displayStep {
    Write-Host $args[0] -ForegroundColor Red -BackgroundColor White
}

# Change Windows explorerer advanced settings via registry
# Args[0] = setting name, Args[1] = value
function setRegistrySettings {
    foreach($setting in $args[0]) {
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name $setting -Value $args[1]
    }
}

function chocolateyProInstall {
    displayStep 'Installing Chocolatey...'
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    New-Item $env:ChocolateyInstall\license -Type Directory -Force
    Copy-Item $chocoLicense $env:ChocolateyInstall\license\chocolatey.license.xml -Force
    choco feature enable -n allowGlobalConfirmation
    choco upgrade chocolatey.extension
}

function installWslUbuntu {
    displayStep 'Installing WSL2...'
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    choco install wsl2
    Start-Process $wslUpdate -Wait
    Start-Process powershell -Wait {
        wsl --set-default-version 2;
        choco install wsl-ubuntu-2004;
    }
    $ubuntuExe = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter ubuntu2004.exe -Recurse
    Start-Process $ubuntuExe -Wait
}

function installPackagesModules {
    displayStep 'Installing Software...'
    choco install $chocoPackages --skip-virus-check

    displayStep 'Installing Yarn Globals...'
    Start-Process powershell -Wait {
        yarn global add $yarnGlobals;
    }

    displayStep 'Installing Powershell Modules...'
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    Install-Package $psModules
}

# Clones eglove/PSSCripts from GitHub to C:\, sets directory as environment variable so scripts can be run
# from terminal.
function clonePsScriptsSetEnv {
    displayStep 'Cloning Powershell Scripts...'
    Set-Location C:\
    Start-Process powershell -Wait {
        gh auth login;
        gh repo clone eglove/PSScripts;
    }
    $env:Path = $env:Path,"C:\PSScripts" -join ";"
    [System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)
}

# Set Registry Settings, changes taskbar look, hides cortana, show hidden files and file extensions
# Explorer will reset for changes to take effect
function applyRegistrySettings {
    displayStep('Applying Registry Settings...')
    setRegistrySettings $advancedSettingsEnable 1
    setRegistrySettings $advancedSettingsDisable 0
    # Not an 'advanced' setting
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0
    Stop-Process -Name "Explorer"
}

# Settings for Jetbrains Toolbox copied from USB. Automatic updates for tools is on. Will generate bash scripts
# for installed tools in C:\PSScripts
function copyJetBrainsSettings {
    displayStep('Applying Jetbrains Toolbox Settings...')
    Copy-Item $jetbrainsSettings $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings -Force
    Copy-Item $jetbrainsSettingsJson $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings.json -Force
}

function cleanup {
    displayStep('Updating Windows and cleaning up...')
    # Update windows
    Get-WindowsUpdate
    Install-WindowsUpdate -AcceptAll

    # Remove desktop shortcuts (includes recycle bin)
    Remove-Item "C:\Users\*\Desktop\*.*" -Force

    # Set execuation policy away from unrestricted
    Set-ExecutionPolicy AllSigned

    # Open disk cleanup tool to safely remove Windows.old
    cleanmgr /d C

    # Delete downloads
    Remove-Item $usbLocation'wslUpdate.msi'
    Remove-Item $usbLocation'script.ps1'
}

chocolateyProInstall
installWslUbuntu
installPackagesModules
clonePsScriptsSetEnv
applyRegistrySettings
copyJetbrainsSettings
cleanup
