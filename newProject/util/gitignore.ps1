function createGitIgnore($types) {
    $gitignoreIo = 'https://www.toptal.com/developers/gitignore/api/';
    $gitIgnoreUrl = $gitignoreIo + $types;
    $gitIgnoreContent = Invoke-WebRequest -Uri $gitIgnoreUrl;
    New-Item .gitignore -Value $gitIgnoreContent;
}