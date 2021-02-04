$commitMessage = args[0];

if ($commitMessage)
{
    git add .
    git commit -m $commitMessage
    git push
}
else
{
    git add .
    git commit
    git push
}