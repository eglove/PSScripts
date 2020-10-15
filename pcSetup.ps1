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
'wsl-ubuntu-2004',
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
Start-Process powershell {
    wsl --set-default-version 2;
    choco install wsl-ubuntu-2004;
    exit;
}

# Install everything else
Write-Host 'Installing Software...' -ForegroundColor Red -BackgroundColor White
choco install $chocoPackages --skip-virus-check
Write-Host 'Installing Yarn Globals...' -ForegroundColor Red -BackgroundColor White
Start-Process powershell {
    yarn global add $yarnGlobals;
    exit;
}
Write-Host 'Installing Powershell Modules...' -ForegroundColor Red -BackgroundColor White
Install-Package $psModules
refreshenv

# Grab PSScripts from GH, run update
Write-Host 'Cloning Powershell Scripts...' -ForegroundColor Red -BackgroundColor White
Set-Location C:\
Start-Process powershell {
    gh repo clone eglove/PSScripts;
    exit;
}
$env:Path += ";C:\PSScripts"
Write-Host 'Updating Everything...' -ForegroundColor Red -BackgroundColor White
update
