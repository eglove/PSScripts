$dependencies = $( 'styled-components', 'styled-reset' )

$devDependencies = @('babel-eslint', 'eslint', 'eslint-config-airbnb', 'eslint-config-prettier',
'eslint-config-wesbos', 'eslint-plugin-graphql', 'eslint-plugin-html', 'eslint-plugin-import',
'eslint-plugin-jsx-a11y', 'eslint-plugin-prettier', 'eslint-plugin-react', 'eslint-plugin-react-hooks', 'prettier',
'stylelint', 'stylelint-a11y', 'stylelint-config-idiomatic-order', 'stylelint-config-prettier',
'stylelint-config-standard', 'stylelint-config-styled-components', 'stylelint-order',
'stylelint-processor-styled-components')

if ($null -ne $args[0])
{
    yarn create next-app $args[0]

    Set-Location $args[0]
    yarn add $dependencies
    yarn add --dev $devDependencies

    Copy-Item $PSScriptRoot'/newProject/.stylelintrc' .stylelintrc
    Copy-Item $PSScriptRoot'/newProject/.eslintrc' .eslintrc
    Copy-Item $PSScriptRoot'/newProject/GlobalStyles.css.js' './styles/GlobalStyles.css.js'
    Copy-Item -Recurse $PSScriptRoot'/newProject/fonts' './styles/fonts'

    mrm lint-staged
    mrm gitignore
    mrm jest
    mrm license --config:name 'Ethan Glover' --config:email 'hello@ethang.email'
    Remove-Item 4
    Remove-Item README.md
} else {
    Write-Host "Requires argument for name of project.";
}
