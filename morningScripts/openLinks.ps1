$morningLinks = @(
'https://hangouts.google.com/?authuser=1',
'https://mail.google.com/mail/u/1/#inbox'
);

$financeLinks = @(
'https://www.payscale.com/login.aspx',
'https://www.paypal.com/',
'https://smile.amazon.com/gp/css/order-history?ie=UTF8&ref_=nav_youraccount_orders&',
'https://docs.google.com/spreadsheets/d/1NRRzw3Ok7my5xRIG6AKKoBadOK3Sca4ZoMg2vhKHxoA/edit',
'https://thevillagesgg.securecafe.com/residentservices/villages-at-general-grant/payments.aspx#tab_MakePayments',
'https://www.ameren.com/',
'https://www.chase.com/',
'https://www.usaa.com/inet/ent_logon/Logon?redirectjsp=true',
'https://www.lightstream.com/account',
'https://www.wealthfront.com/',
'https://www.lendingclub.com/',
'https://app.monarchmoney.com/dashboard'
);

function openLinksArray($links)
{
    foreach ($link in $links)
    {
        Start-Process Chrome $link
    }
}

function openLinks
{
    $today = Get-Date
    if ( $today.DayOfWeek.ToString().Equals("Saturday"))
    {
        openLinksArray($financeLinks)
    }

    openLinksArray($morningLinks)
}