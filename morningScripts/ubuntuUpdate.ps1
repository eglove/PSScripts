$wslPassword = (Select-String -Path .env -Pattern 'wslPassword=').ToString().Split('=')[1];
$wslUpdateCommand = "echo " + $wslPassword + " | sudo -S apt update && sudo apt upgrade -y && sudo apt autoremove"
Start-Process wsl -ArgumentList $wslUpdateCommand