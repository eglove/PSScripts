$resourceLocation = $PSScriptRoot + '/newProject/';

$projectTypes = @(
'typescript'
)

function getHelp()
{
    Write-Host 'createProject [projectName] [projectType]';
    Write-Host 'Valid Project Types:';
    Write-Host 'typescript';
    exit;
}

if ('help' -eq $args[0] -or $null -eq $args[0] -or $null -eq $args[1])
{
    getHelp;
}

$projectName = [System.IO.FileInfo]$args[0];

if (!$projectTypes.Contains($args[1]))
{
    getHelp;
}
else
{
    $projectType = $args[1];
}

$workspace = '~/Projects';

Set-Location $workspace;
mkdir $projectName
Set-Location $projectName

if ('typescript' -eq $projectType)
{
    $projectScript = $resourceLocation + $projectType + '/run.ps1';
    Invoke-Expression $projectScript;
}
