choco upgrade all -y --skip-virus-check
choco list -l -r --id-only | Out-File ..\installedChocoPackages.txt