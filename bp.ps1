$GHPages, $ProjectName, $ProjectDir, $File, $TextToAppendAt, $TextToAdd, $NewContent;

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

[String[]]$dependenciesBack =
'bcrypt',
'compression',
'cors',
'express',
'jsonwebtoken',
'knex',
'morgan'

[String[]]$devDependenciesBack =
'nodemon'

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
    $PackageName = '"name": "test",'
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

$ProjectName = Read-Host -Prompt 'Project Name';
#$GHPages = Read-Host -Prompt 'Will you use GitHub pages? (y/n)'

$ProjectDir = 'C:\Users\thora\IdeaProjects\' + $ProjectName + '\'
mkdir $ProjectDir
Set-Location $ProjectDir

Write-Host 'Initializing Git...'
git init
gh repo create

Write-Host 'Building Frontend...'
$FrontLocation = $ProjectDir + 'front'
Set-Location $ProjectDir
yarn create react-app front
Set-Location $FrontLocation
Remove-Item Readme.md
yarn add $dependenciesFront
yarn add --dev $devDependenciesFront
mrm jest
mrm lint-staged
Remove-Item 4
WriteLintConfig

#if ($GHPages -eq 'y') {
#    GHPages
#}

Write-Host 'Building Backend...'
$BackLocation = $ProjectDir + 'back'
mkdir $BackLocation
Set-Location $BackLocation
yarn init -y
yarn add $dependenciesBack
yarn add --dev $devDependenciesBack
mrm gitignore

# TODO Write Docker Files
# Docker services:
# PostGres (DB), Redis (Session Management)

Write-Host 'Wrapping up...'
Set-Location $ProjectDir
mrm readme --config:url $MyUrl --config:name $MyName --config:github $GitUsername --config:packageName $ProjectName
mrm license --config:license "MIT" --config:name $MyName --config:email $MyEmail --config:url $MyUrl
mrm gitignore

Clear-Host
Write-Host $ProjectName build is Complete! -ForegroundColor DarkGreen
Write-Host 'Available at '+$ProjectDir -ForegroundColor DarkMagenta
idea
