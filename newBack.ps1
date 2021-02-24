$dependencies = @("@keystone-next/admin-ui", "@keystone-next/auth", "@keystone-next/cloudinary",
    "@keystone-next/fields", "@keystone-next/keystone", "@keystone-next/types",
    "@keystonejs/server-side-graphql-client", "@types/nodemailer", "dotenv", "next", "nodemailer", "react",
    "react-dom");

if ($null -ne $args[0])
{
    mkdir $args[0]
    Set-Location $args[0]

    yarn init -y
    yarn add $dependencies

    Copy-Item $PSScriptRoot"/newProject/.eslintrc" .eslintrc

    npx install-peerdeps --dev eslint-config-wesbos
    mrm lint-staged
    mrm gitignore
    mrm jest
    mrm license --config:name "Ethan Glover" --config:email "hello@ethang.email"
    Remove-Item 4
    Remove-Item README.md
    webstorm .
} else {
    Write-Host "Requires argument for name of project.";
}