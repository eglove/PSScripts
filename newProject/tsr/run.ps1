. 'C:\PSScripts\newProject\util\gitignore.ps1';

$copyFiles = $PSScriptRoot + '\copyFiles\*';

$dependencies = @(
    '@apollo/client',
    'apollo-server',
    'graphql',
    'next',
    'nprogress',
    'react',
    'react-dom',
    'styled-components',
    'styled-reset'
);

$devDependencies = @(
    '@types/jest',
    '@types/node',
    '@types/nprogress',
    '@types/react',
    '@types/styled-components',
    '@typescript-eslint/eslint-plugin',
    '@typescript-eslint/parser',
    'eslint',
    'eslint-config-airbnb-typescript',
    'eslint-config-prettier',
    'eslint-plugin-import',
    'eslint-plugin-jsx-a11y',
    'eslint-plugin-prettier',
    'eslint-plugin-react',
    'eslint-plugin-react-hooks',
    'eslint-plugin-simple-import-sort',
    'eslint-plugin-sonarjs',
    'husky',
    'jest',
    'lint-staged',
    'nodemon',
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

createGitIgnore('jetbrains,node,vscode,vim');

$projectName = Get-Location | Select-Object | ForEach-Object{$_.ProviderPath.Split("\")[-1]}
((Get-Content -path 'package.json' -Raw) -replace 'REPLACE_NAME', $projectName) | Set-Content -Path 'package.json'

yarn add $dependencies;
yarn add -D $devDependencies

webstorm .
