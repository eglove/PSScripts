$eamResources = '\eam_app\eam.resources'
$projectLocation = $HOME+'\IdeaProjects\MYA-R38'
$projectPropertiesLocation = $projectLocation+'\build\classes'
$backupLocation = $HOME+'\OneDrive - CenturyLink\Backup'
$e2eProperties = $backupLocation+'\e2e-properties'
$test1Properies = $backupLocation+'\test1-properties'
$test2Properties = $backupLocation+'\test2-properties'

function runAnt {
    Set-Location $projectLocation
    Write-Host -ForegroundColor Red 'Running Ant clean.'
    ant clean
    Write-Host -ForegroundColor Red 'Running Ant Compile JUnit Source.'
    ant compile-junit-source
    Write-Host -ForegroundColor Red 'Running Ant Package Tar.'
    ant package-tar
}

$targetEnv = Read-Host 'Environment to switch to (e2e, test1, test2)'

$propertiesDir = Get-ChildItem $e2eProperties
Switch ($targetEnv) {
    'e2e' {
        $propertiesDir = Get-ChildItem $e2eProperties
    }
    'test1' {
        $propertiesDir = Get-ChildItem $test1Properies
    }
    'test2' {
        $propertiesDir = Get-ChildItem $test2Properties
    }
}

Write-Host -ForegroundColor Red 'Copying properties backup to '$eamResources
Copy-Item -Path $propertiesDir -Destination $eamResources -Recurse -Force
Write-Host -ForegroundColor Red 'Removing build directory.'
Remove-Item -Recurse -Force $projectLocation'\build'
Write-Host -ForegroundColor Red 'Removing dist directory.'
Remove-Item -Recurse -Force $projectLocation'\dist'
runAnt
Write-Host -ForegroundColor Red 'Copying '$eamResources' to '$projectPropertiesLocation
Copy-Item -Path $eamResources -Destination $projectPropertiesLocation -Recurse -Force
runAnt
