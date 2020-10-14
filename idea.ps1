# Search for idea.exe to always have latest version
$toolboxApps = 'C:\Program Files\JetBrains'
$ideaPath = Get-ChildItem -Path $toolboxApps -Filter idea.exe -Recurse -ErrorAction SilentlyContinue -Force
Start-Process $ideaPath . -Verb RunAs
