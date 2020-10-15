<#
GH Clone PSScripts
Update
 #>

[String[]]$psModules =
'PSWindowsUpdate'

[String[]]$yarnGlobals =
'mrm'

[String[]]$chocoPackages =
'0ad'
'anki'
'autoclicker'
'balabolka'
'everything'
'f.lux'
'foxitreader'
'gh'
'git'
'google-backup-and-sync'
'GoogleChrome'
'imagemagick'
'intellijidea-ultimate'
'jbs'
'microsoft-windows-terminal'
'minecraft-launcher'
'nodejs'
'notepadplusplus'
'obs-studio'
'ojdkbuild'
'picpick.portable'
'powershell-core'
'speccy'
'steam'
'terminus'
'twitch'
'vim'
'vlc'
'vortex'
'vscode'
'wsl-ubuntu-2004'
'yarn'

# Chocolatey Pro install
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Update-SessionEnvironment
New-Item $env:ChocolateyInstall\license -Type Directory -Force
Copy-Item $PSScriptRoot\chocolatey.license.xml $env:ChocolateyInstall\license\chocolatey.license.xml -Force
choco upgrade chocolatey.extension
Update-SessionEnvironment

# WSL2 Install
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
choco install wsl2
Update-SessionEnvironment
wsl --set-default-version 2
choco install wsl-ubuntu-2004

# Install everything else
choco install $chocoPackages
yarn global add $yarnGlobals
Install-Package $psModules
Update-SessionEnvironment

# Grab PSScripts from GH, run update
Set-Location C:\
gh repo clone eglove/PSScripts
$env:Path += ";C:\PSScripts"
update

