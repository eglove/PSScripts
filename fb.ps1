﻿$GHPages, $ProjectName, $ProjectDir, $File, $TextToAppendAt, $TextToAdd, $NewContent;

[String[]]$dependenciesFront =
'dotenv',
'isomorphic-unfetch',
'prop-types',
'react-redux',
'redux',
'redux-thunk',
'styled-components'

[String[]]$devDependenciesFront =
'babel-eslint',
'eslint',
'eslint-config-airbnb',
'eslint-config-prettier',
'eslint-config-wesbos',
'eslint-plugin-html',
'eslint-plugin-import',
'eslint-plugin-jsx-a11y',
'eslint-plugin-prettier',
'eslint-plugin-react',
'eslint-plugin-react-hooks',
'prettier',
'redux-logger',
'redux-mock-store',
'stylelint',
'stylelint-config-standard'

$MyUrl = "https://github.com/eglove"
$MyName = "Ethan Glover"
$MyEmail = "hello@ethang.email"
$GitUsername = "eglove"
$PackageJson = '.\package.json'

function WriteLintConfig
{
    New-Item .stylelintrc -value '{
    "extends": "stylelint-config-standard"
}'
    New-Item .eslintrc -value '{
    "extends": [
        "wesbos"
    ]
}'

    (Get-Content -path $PackageJson -Raw) -replace '"*.js": "eslint --cache --fix",', '": "eslint --cache --fix",' | Set-Content $PackageJson
}

function GHPages
{
    yarn add gh-pages --dev
    $PackageName = '"name": ' + $ProjectName + ','
    $PackageHomepage = '  "homepage": "http://eglove.github.io/' + $ProjectName + '",'
    $PackageScriptsStart = '"scripts": {'
    $PackagePreDeploy = '    "predeploy": "npm run build",'
    $PackagePostDeploy = '    "deploy": "gh-pages -d build",'
    AppendFile $PackageName $PackageHomepage $PackageJson;
    AppendFile $PackageScriptsStart $PackagePreDeploy $PackageJson
    AppendFile $PackagePreDeploy $PackagePostDeploy $PackageJson;
}

function AppendFile($TextToAppendAt, $TextToAdd, $File)
{
    $NewContent = Get-Content -Path $File |
            ForEach-Object {
                $_
                if ($_ -match $TextToAppendAt)
                {
                    $TextToAdd
                }
            }
    $NewContent | Out-File -FilePath $File -Encoding Default -Force
}

$IdeaDir = 'C:\Users\thora\IdeaProjects\'
$ProjectName = Read-Host -Prompt 'Project Name';
$GHPages = Read-Host -Prompt 'Will you use GitHub pages? (y/n)'
$ProjectDir = $ProjectDir + $ProjectName + '\'
Set-Location $IdeaDir
gh repo create $ProjectName

Set-Location $IdeaDir
yarn create react-app $ProjectName
Set-Location $ProjectDir
Remove-Item Readme.md
yarn add $dependenciesFront
yarn add --dev $devDependenciesFront
mrm jest
mrm lint-staged
Remove-Item 4
WriteLintConfig

if ($GHPages -eq 'y') {
    GHPages
}

mrm readme --config:url $MyUrl --config:name $MyName --config:github $GitUsername --config:packageName $ProjectName
mrm license --config:license "MIT" --config:name $MyName --config:email $MyEmail --config:url $MyUrl
mrm gitignore

Clear-Host
Write-Host $ProjectName build is Complete! -ForegroundColor DarkGreen
Write-Host 'Available at ' + $ProjectDir -ForegroundColor DarkMagenta
idea
