$settingsToBackup = @(
'~/AppData/Local/JetBrains/Toolbox/.settings',
'~/AppData/Local/JetBrains/Toolbox/.settings.json',
'~/AppData/Roaming/terminus/config.yaml'
);

foreach ($setting in $settingsToBackup)
{
    Copy-Item $setting ./settingsBackup
}

Get-ChildItem '../settingsBackup' | Format-Table Name -HideTableHeaders | Out-File '../backedUpSettings.txt'
(Get-Content '../backedUpSettings.txt') | Where-Object { $_.trim() -ne "" } | Set-Content '../backedUpSettings.txt'