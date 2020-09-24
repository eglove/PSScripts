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

$ProjectName = Read-Host -Prompt 'Project Name';
$IdeaDir = 'C:\Users\thora\IdeaProjects\'
$BackLocation = $IdeaDir + $ProjectName + '\back'
mkdir $BackLocation
Set-Location $BackLocation
yarn init -y
yarn add $dependenciesBack
yarn add --dev $devDependenciesBack
mrm readme --config:url $MyUrl --config:name $MyName --config:github $GitUsername --config:packageName $ProjectName
mrm license --config:license "MIT" --config:name $MyName --config:email $MyEmail --config:url $MyUrl
mrm gitignore

# TODO Write Docker Files
# Docker services:
# PostGres (DB), Redis (Session Management)
