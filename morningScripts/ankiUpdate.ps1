$ankiBackupLocation = 'C:\Users\eglove\AppData\Roaming\Anki2';

Set-Location $ankiBackupLocation
git add .
git commit -m "Anki Automatic Backup"
if ($?)
{
    git push
}