. 'C:\PSScripts\newProject\util\gitignore.ps1';

$copyFiles = $PSScriptRoot + '\copyFiles\*';

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
    'lint-staged',
    'prettier',
    'stylelint',
    'stylelint-a11y',
    'stylelint-config-idiomatic-order',
    'stylelint-config-prettier',
    'stylelint-config-standard',
    'stylelint-config-styled-components',
    'stylelint-order',
    'stylelint-processor-styled-components',
    'ts-jest',
    'typescript'
);

Copy-Item -Path $copyFiles -Destination . -Recurse

createGitIgnore('jetbrains,node,vscode');

$projectName = Get-Location | Select-Object | ForEach-Object{$_.ProviderPath.Split("\")[-1]}
((Get-Content -path 'package.json' -Raw) -replace 'REPLACE_NAME', $projectName) | Set-Content -Path 'package.json'

yarn add $dependencies;
yarn add -D $devDependencies

webstorm .
