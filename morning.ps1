# web developer, front end developer, javascript, react
$links = @(
'https://docs.google.com/spreadsheets/d/16K1DybdEvhb3ng0mtlp02sd3M9aukLXB9fzKE9oCXKk/edit#gid=0',
'https://www.resumerabbit.com/mail',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=react&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=javascript&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=front%20end%20developer&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=web%20developer&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=react&location=United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=javascript&location=United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=front%20end%20developer&location=United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=web%20developer&location=United%20States'
)

function update {
    Write-Host 'Updating...'
    Get-WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll
    Update-Module -AcceptLicense
    yarn global upgrade
    choco upgrade all
    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait
}

function openLinks {
    Start-Process 'C:\Program Files\Anki\anki.exe'
    foreach($link in $links) {
        Start-Process chrome $link, '--profile-directory="Default"'
    }
}

function morningRoutine {
    update
    openLinks
}

morningRoutine
# Prevent exit when auto running
Read-Host -Prompt "Press Enter to exit"
