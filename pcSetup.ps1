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

# Chocolatey Pro install
Write-Host 'Installing Chocolatey...' -ForegroundColor Red -BackgroundColor White
Set-ExecutionPolicy Unrestricted
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv
New-Item $env:ChocolateyInstall\license -Type Directory -Force
Copy-Item $PSScriptRoot\chocolatey.license.xml $env:ChocolateyInstall\license\chocolatey.license.xml -Force
choco feature enable -n allowGlobalConfirmation
choco upgrade chocolatey.extension
refreshenv

# WSL2 Install
Write-Host 'Installing WSL2...' -ForegroundColor Red -BackgroundColor White
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
choco install wsl2
Start-Process powershell -Wait {
    wsl --set-default-version 2;
    choco install wsl-ubuntu-2004;
}

# Install everything else
Write-Host 'Installing Software...' -ForegroundColor Red -BackgroundColor White
choco install $chocoPackages --skip-virus-check
Write-Host 'Installing Yarn Globals...' -ForegroundColor Red -BackgroundColor White
Start-Process powershell -Wait {
    yarn global add $yarnGlobals;
}
Write-Host 'Installing Powershell Modules...' -ForegroundColor Red -BackgroundColor White
Install-Package $psModules
refreshenv

# Grab PSScripts from GH, run update
Write-Host 'Cloning Powershell Scripts...' -ForegroundColor Red -BackgroundColor White
Set-Location C:\
Start-Process powershell -Wait {
    gh auth login
}
Start-Process powershell -Wait {
    gh repo clone eglove/PSScripts;
    exit
}
$env:Path = $env:Path,"C:\PSScripts" -join ";"
[System.Environment]::SetEnvironmentVariable('Path', $env:Path, [System.EnvironmentVariableTarget]::Machine)

Write-Host 'Updating Everything...' -ForegroundColor Red -BackgroundColor White
# Update Modules -AcceptLicense requires Powershell7+
Start-Proccess pwsh -Wait {
    update
}

# Remove desktop shortcuts
Remove-Item "C:\Users\*\Desktop\*.*" -Force
# Small Taskbar Icons
Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name TaskbarSmallIcons -Value 1
# Taskbar icons combine when full
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarGlomLevel -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarEnabled -Value 1
# Show taskbar on mutliple displays
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarGlomLeve -Value 1
# Hide Cortana
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -Value 0
# Show all tray icons
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0
# Show Hidden Files
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1
Stop-Process -Name "Explorer"

# Set Intellij Toolbox settings (will generate new idea script)
Copy-Item $PSScriptRoot\.settings $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings -Force
Copy-Item $PSScriptRoot\.settings.json $env:USERPROFILE\AppData\Local\Jetbrains\Toolbox\.settings.json -Force
