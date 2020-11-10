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

# Args[0] = source, Args[1] = destination
function copyPropertiesFiles {
    Write-Host -ForegroundColor Red 'Copying '$args[0]' to '$args[1]
    $files = Get-ChildItem $args[0] -Filter *.properties -Recurse
    foreach($file in $files) {
        Copy-Item $file $args[1] -Force
    }
    $files = Get-ChildItem $args[0] -Filter log4j2.xml
    foreach($file in $files) {
        Copy-Item $file $args[1] -Force
    }
}

$targetEnv = Read-Host 'Environment to switch to (e2e, test1, test2)'

$propertiesDir = $e2eProperties
Switch ($targetEnv) {
    'e2e' {
        $propertiesDir = $e2eProperties
    }
    'test1' {
        $propertiesDir = $test1Properies
    }
    'test2' {
        $propertiesDir = $test2Properties
    }
}

copyPropertiesFiles $propertiesDir $eamResources

Write-Host -ForegroundColor Red 'Removing build directory.'
Remove-Item -Recurse -Force $projectLocation'\build'

Write-Host -ForegroundColor Red 'Removing dist directory.'
Remove-Item -Recurse -Force $projectLocation'\dist'

runAnt
copyPropertiesFiles $eamResources $projectPropertiesLocation
runAnt
