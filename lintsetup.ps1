$dependencies = $('styled-components')

$devDependencies = @('babel-eslint', 'eslint', 'eslint-config-airbnb', 'eslint-config-prettier',
'eslint-config-wesbos', 'eslint-plugin-graphql', 'eslint-plugin-html', 'eslint-plugin-import',
'eslint-plugin-jsx-a11y', 'eslint-plugin-prettier', 'eslint-plugin-react', 'eslint-plugin-react-hooks', 'prettier',
'stylelint', 'stylelint-a11y', 'stylelint-config-idiomatic-order', 'stylelint-config-prettier',
'stylelint-config-standard', 'stylelint-config-styled-components', 'stylelint-order',
'stylelint-processor-styled-components')

yarn add $dependencies
yarn add --dev $devDependencies

Copy-Item 'C:\PSScripts\.stylelintrc' .stylelintrc
Copy-Item 'C:\PSScripts\.eslintrc' .eslintrc

mrm lint-staged
Remove-Item 4
