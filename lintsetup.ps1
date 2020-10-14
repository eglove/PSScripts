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
'eslint-plugin-jex-a11y',
'eslint-plugin-prettier',
'eslint-plugin-react',
'eslint-plugin-react-hooks',
'prettier',
'stylelint',
'stylelint-config-standard',
'stylelint-config-styled-components',
'stylelint-processor-styled-components'

yarn add $dependencies
yarn add --dev $devDependencies

New-Item .stylelintrc -value '{
  "processors": [
  "stylelint-processor-styled-components"
  ],
  "extends": [
  "stylelint-config-standard",
  "stylelint-config-styled-components"
  ]
}'

New-Item -vale '{
  "extends": [
  "wesbos"
  ]
}'

mrm lint-staged
