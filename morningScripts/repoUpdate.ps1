Set-Location '\PSScripts'
$commitMessage = [System.Text.StringBuilder]::new()
$commitMessage.Append('Automatic update: ');
$date = Get-Date -Format u
$commitMessage.Append($date)

git add .
git commit -m $commitMessage.ToString()

if ($?)
{
    git push
}
else
{
    Add-Content -Path .\theGraph.txt 'The GitHub contribution graph is a lie.'
    git add .
    git commit -m $commitMessage.ToString()
    git push
}