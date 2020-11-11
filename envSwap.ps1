# CHANGE THESE - Don't include slashes after directories
$eamAppLocation = '/eam_app'
$eamAppExternalLocation = '/eam_app/external'
$eamResourcesLocation = '/eam_app/eam.resources'
# Root of project containing source
# $HOME = User home (ex. C:/Users/AC71399), same as ~/
$projectLocation = $HOME+'/IdeaProjects/MYA-R38'

# DON'T CHANGE THESE
# Location of .e2e, .test, .test2 property files
$propertiesOriginalLocation = $projectLocation+'/data/config'
# Build directory generated by ant process
$projectPropertiesLocation = $projectLocation+'/build/classes'
# No need to change these, you will be asked for environment when script runs
$targetEnvironment = 'e2e'
$filter = '*.e2e'

function deleteBuildFiles {
    Write-Host -ForegroundColor Red 'Removing build files...'
    Remove-Item -Recurse -Force $projectLocation'/build'
    Remove-Item -Recurse -Force $projectLocation'/dist'
}

function copyPropertiesFilesToEamResources {
    Write-Host -ForegroundColor Red 'Grabbing' $targetEnvironment 'files from project...'
    $filter = '*.' + $targetEnvironment
    $files = Get-ChildItem $propertiesOriginalLocation -Filter $filter -Recurse

    # Copy properties files from project to eam.resources
    $files | ForEach-Object {
        $file = Get-ChildItem $_.FullName
        Copy-Item $file $eamResourcesLocation -Force
    }
}

function deleteCurrentPropertiesFiles {
    Write-Host -ForegroundColor Red 'Deleting current properties files...'
    # Delete current properties files
    $files = Get-ChildItem $eamResourcesLocation -Filter *.properties -Recurse
    $files | ForEach-Object {
        $file = Get-ChildItem $_.FullName
        Remove-Item $file
    }
    Remove-Item $eamResourcesLocation'/log4j2.xml'
}

function rewritePropertiesFiles {
    Write-Host -ForegroundColor Red 'Rewriting properties files...'
    # Remove file extensions from new properties files
    $files = Get-ChildItem $eamResourcesLocation -Filter $filter -Recurse
    $files | ForEach-Object {
        $file = Get-ChildItem $_.FullName
        Rename-Item -Path $file -NewName $file.BaseName -Force
    }

    # Replace local paths
    $files = Get-ChildItem $eamResourcesLocation -Filter *.properties -Recurse
    $resourceLocation = '/foss/foss-ews/instances/myajws-'+$targetEnvironment+'/current/Qwest/config'
    Write-Host $resourceLocation
    $files | ForEach-Object {
        $file = Get-ChildItem $_.FullName
        (Get-Content -Path $file) | ForEach-Object {
            $_ -replace '/contentshare/content/share/dimensions/dimns/env/webdmzpt1/dotcom_static', $eamAppLocation
        } | Set-Content -Path $file
        (Get-Content -Path $file) | ForEach-Object {
            $_ -replace '/contentshare/content/share/dimensions/dimns/env/webdmzpt1/eam_static', $eamAppExternalLocation
        } | Set-Content -Path $file
        (Get-Content -Path $file) | ForEach-Object {
            $_ -replace $resourceLocation, $eamResourcesLocation
        } | Set-Content -Path $file
    }
}

function runAnt {
    Set-Location $projectLocation
    Write-Host -ForegroundColor Red 'Running Ant...'
    ant clean
    ant compile-junit-source
    ant package-tar
}

function copyPropertiesFilesToProject {
    Write-Host -ForegroundColor Red 'Copying properties files to project...'
    $files = Get-ChildItem $eamResourcesLocation -Filter *.properties -Recurse
    $files | ForEach-Object {
        $file = Get-ChildItem $_.FullName
        Copy-Item $file $projectPropertiesLocation -Force
    }
    Copy-Item $eamResourcesLocation'/log4j2.xml' $projectPropertiesLocation -Force
}

function propertiesSetup {
    deleteBuildFiles
    copyPropertiesFilesToEamResources
    deleteCurrentPropertiesFiles
    rewritePropertiesFiles
    runAnt
    copyPropertiesFilesToProject
    runAnt
}

$targetEnvironment = Read-Host 'Environment to switch to (e2e, test1, test2...)'
$filter = '*.'+$targetEnvironment
propertiesSetup
