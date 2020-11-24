# web developer, front end developer, javascript, react
$links = @(
'https://docs.google.com/spreadsheets/d/16K1DybdEvhb3ng0mtlp02sd3M9aukLXB9fzKE9oCXKk/edit#gid=0',
'https://www.resumerabbit.com/mail',
'https://remotive.io/?live_jobs%5Bquery%5D=react&live_jobs%5BsortBy%5D=live_jobs_sort_by_date',
'https://remotive.io/?live_jobs%5Bquery%5D=javascript&live_jobs%5BsortBy%5D=live_jobs_sort_by_date',
'https://remotive.io/?live_jobs%5Bquery%5D=front%20end%20developer&live_jobs%5BsortBy%5D=live_jobs_sort_by_date',
'https://remotive.io/?live_jobs%5Bquery%5D=web%20developer&live_jobs%5BsortBy%5D=live_jobs_sort_by_date',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=react&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=javascript&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=front%20end%20developer&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=104428936&keywords=web%20developer&location=St%20Louis%2C%20Missouri%2C%20United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=react&location=United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=javascript&location=United%20States',
'https://www.linkedin.com/jobs/search/?f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=front%20end%20developer&location=United%20States',
'https://www.linkedin.com/jobs/search/?currentJobId=2213595016&f_CF=f_WRA&f_E=2&f_JT=F&f_LF=f_AL&f_TPR=r86400&geoId=103644278&keywords=web%20developer&location=United%20States'
)

function update {
    Write-Host 'Updating...'
    Get-WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll
    Update-Module -AcceptLicense
    yarn global upgrade
    choco upgrade all
    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait
    Start-Process wsl -ArgumentList "pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U" -Wait
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
