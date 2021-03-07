$gitignoreLink = 'https://www.toptal.com/developers/gitignore/api/';
$items = $args
$ignores = ''

# Get Custom Ignores
foreach ($item in $items)
{
    if ( $item.ToString().Equals('next'))
    {
        $ignores += "`n### Nextjs ###`n.next/`n"
        $items = $items | Where-Object { $_ -ne $item }
    }
    elseif ( $item.ToString().Equals('keystone'))
    {
        $ignores += "`n### Keystonejs ###`n.keystone/`n"
        $items = $items | Where-Object { $_ -ne $item }
    }
}

# Always ignore eslint cache
$ignores += "`n### ESLint ###`n.eslintcache/`n"

# Get Ignores Link From Toptal
for ($i = 0; $i -lt $items.Count; $i++)
{
    $gitignoreLink += $items[$i]

    if ($i -ne $items.Count - 1)
    {
        $gitignoreLink += ','
    }
}

$ignores += Invoke-WebRequest -Uri $gitignoreLink | Select-Object -ExpandProperty content

$ignores | Out-File -FilePath $( Join-Path -path $PWD -ChildPath ".gitignore" ) -Encoding ascii