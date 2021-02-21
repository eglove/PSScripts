$devDependencies = @('babel-eslint', 'eslint', 'eslint-config-airbnb', 'eslint-config-prettier',
'eslint-config-wesbos', 'eslint-plugin-graphql', 'eslint-plugin-html', 'eslint-plugin-import',
'eslint-plugin-jsx-a11y', 'eslint-plugin-prettier', 'eslint-plugin-react', 'eslint-plugin-react-hooks', 'prettier')

if ($null -ne $args[0])
{
    yarn create keystone-app $args[0]

    Set-Location $args[0]
    yarn add --dev $devDependencies

    mrm lint-staged
    mrm gitignore
    mrm jest
    mrm license --config:name 'Ethan Glover' --config:email 'hello@ethang.email'
    Remove-Item 4
    Remove-Item README.md
}