[String[]]$dependencies =
'styled-components'

[String[]]$devDependencies =
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
'stylelint',
'stylelint-a11y',
'stylelint-config-standard',
'stylelint-config-styled-components',
'stylelint-order',
'stylelint-processor-styled-components'

yarn add $dependencies
yarn add --dev $devDependencies

Copy-Item 'C:\PSScripts\.stylelintrc' .stylelintrc
Copy-Item 'C:\PSScripts\.eslintrc' .eslintrc

mrm lint-staged
rm 4
