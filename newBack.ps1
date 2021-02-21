if ($null -ne $args[0])
{
    yarn create keystone-app $args[0]
    Set-Location $args[0]
}