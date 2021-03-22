$resourceLocation = $PSScriptRoot + '/newProject/';

$projectTypes = @(
'typescript'
)

function getHelp()
{
    Write-Host 'createProject [projectName] [projectType]';
    Write-Host 'Valid Project Types:';
    Write-Host 'TSR: TypeScript-React';
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

$createGitHub = Read-Host "Create GitHub Project? (y/n)"

$workspace = '~/Projects';

Set-Location $workspace;
mkdir $projectName
Set-Location $projectName

if ('TSR' -eq $projectType)
{
    $projectScript = $resourceLocation + $projectType + '/run.ps1';
    Invoke-Expression $projectScript;
}

if ($createGitHub -eq 'y')
{
    git init
    gh repo create $projectName --confirm --public
    git add .
    $initalizeMessage = "Initialize " + $projectType + " project " + $projectName + ".";
    git commit -m $initalizeMessage
    git push --set-upstream origin master
}
