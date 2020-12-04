# web developer, front end developer, javascript, react
$links = @(
'https://mail.google.com/mail/u/1/#inbox',
'https://feedly.com/',
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

$financeLinks = @(
'https://www.glassdoor.com/knowyourworth/dashboard.htm',
'https://www.paypal.com/',
'https://smile.amazon.com/gp/css/order-history?ie=UTF8&ref_=nav_youraccount_orders&',
'https://docs.google.com/spreadsheets/d/1NRRzw3Ok7my5xRIG6AKKoBadOK3Sca4ZoMg2vhKHxoA/edit',
'https://thevillagesgg.securecafe.com/residentservices/villages-at-general-grant/payments.aspx#tab_MakePayments',
'https://www.ameren.com/account/prot/dashboard',
'https://www.chase.com/',
'https://www.usaa.com/inet/ent_logon/Logon?redirectjsp=true',
'https://www.lightstream.com/account',
'https://www.wealthfront.com/',
'https://www.lendingclub.com/',
'https://app.youneedabudget.com/c746a430-c29a-4c3d-887e-2684a331015a/budget',
'https://www.fieldglass.net/worker_desktop.do?cf=1',
'https://myapex.apexsystemsinc.com/psp/MYAPEX/CONTRACTOR/HRMS/c/APEX.AX_HOME_PAGE.GBL?FolderPath=PORTAL_ROOT_OBJECT.AX_HOME_PAGE&IsFolder=false&IgnoreParamTempl=FolderPath%2cIsFolder'
)

function update {
    Write-Host 'Updating...'
    Get-WindowsUpdate -WindowsUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -WindowsUpdate
    Get-WindowsUpdate -MicrosoftUpdate
    Install-WindowsUpdate -AutoReboot -AcceptAll -MicrosoftUpdate
    Update-Module -AcceptLicense -Confirm
    yarn global upgrade
    choco upgrade all
    Start-Process wsl -ArgumentList "sudo apt update && sudo apt upgrade -y && sudo apt autoremove" -Wait
}

function openLinks {
    Start-Process 'C:\Program Files\Anki\anki.exe'

    $today = Get-Date
    if ($today.DayOfWeek.Equals("Saturday")) {
        foreach($link in $financeLinks) {
            Start-Process chrome $link, '--profile-directory="Default"'
        }
    }

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
