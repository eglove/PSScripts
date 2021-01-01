$apps = @(
'C:\Users\eglove\AppData\Local\Zygor\Zygor.exe',
'C:\Users\eglove\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Overwolf\CurseForge.lnk',
'C:\Wowhead_Client.exe',
'C:\Program Files (x86)\Battle.net\Battle.net Launcher.exe'
)

foreach($app in $apps) {
    Start-Process $app
}

$simcLocation = Get-ChildItem -Path C:\simc -Filter SimulationCraft.exe -Recurse
Start-Process $simcLocation