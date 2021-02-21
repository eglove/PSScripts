$dependencies = $( 'prop-types', 'styled-components', 'styled-reset' )

$devDependencies = @('stylelint', 'stylelint-a11y', 'stylelint-config-idiomatic-order',
'stylelint-config-prettier', 'stylelint-config-standard', 'stylelint-config-styled-components', 'stylelint-order',
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

    npx install-peerdeps --dev eslint-config-wesbos
    mrm lint-staged
    mrm gitignore
    mrm jest
    mrm license --config:name 'Ethan Glover' --config:email 'hello@ethang.email'
    Remove-Item 4
    Remove-Item README.md
    webstorm .
} else {
    Write-Host "Requires argument for name of project.";
}
