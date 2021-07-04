Write-Output 'A' | yarn global upgrade
$installedYarnPackagesFile = '..\installedYarnPackages.txt'
$installedPackages = yarn global list
Out-File $installedYarnPackagesFile
ForEach ($line in $($installedPackages -split "`r`n"))
{
    if ($line -match 'info')
    {
        $line | Select-String -Pattern "\b(?!info|has|binaries|\d|\d\d\b)[a-zA-Z-/]+" -AllMatches | ForEach-Object {
            Add-Content $installedYarnPackagesFile $_.matches.value.toString()
        }
    }
}