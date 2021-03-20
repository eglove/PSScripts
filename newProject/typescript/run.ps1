. 'C:\PSScripts\newProject\util\gitignore.ps1';

$projectTypeResources = $PSScriptRoot + '\newProject\typescript';
$copyFiles = $projectTypeResources + '\copyFiles';

$dependencies = @('styled-components');

$devDependencies = @(
    '@types/jest',
    '@types/node',
    '@typescript-eslint/eslint-plugin',
    '@typescript-eslint/parser',
    'audit-ci',
    'eslint',
    'eslint-config-prettier',
    'eslint-plugin-prettier',
    'eslint-plugin-sonarjs',
    'husky',
    'jest',
    'jest-sonar-reporter',
    'lint-staged',
    'prettier',
    'sonarjs',
    'sonarqube-scanner',
    'sonarqube-verify',
    'stylelint',
    'stylelint-a11y/recommended',
    'stylelint-config-idiomatic-order',
    'stylelint-config-prettier',
    'stylelint-config-standard',
    'stylelint-config-styled-components',
    'stylelint-order',
    'stylelint-processor-styled-components',
    'ts-jest',
    'typescript'
);

foreach($item in $copyFiles) {
    Copy-Item -Recurse $item .
}

createGitIgnore('jetbrains,node,vscode');

$projectName = Get-Location | Select-Object | ForEach-Object{$_.ProviderPath.Split("\")[-1]}
((Get-Content -path 'package.json' -Raw) -replace 'NAME', $projectName) | Set-Content -Path 'package.json'

yarn add $dependencies;
yarn add -D $devDependencies
