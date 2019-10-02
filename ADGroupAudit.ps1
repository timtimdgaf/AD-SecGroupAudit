If (!(Test-Path "C:\temp\Group Audit\groups")) { $null = New-Item "C:\temp\Group Audit\groups" -ItemType directory }

$GroupList = Get-ADGroup -Filter 'GroupCategory -eq "Security" -and GroupScope -ne "DomainLocal"'

ForEach ($Entry in $GroupList) {
    $dn = $Entry.DistinguishedName
    
    Get-ADObject -Filter 'memberOf -recursivematch $dn' -Properties description, SamAccountName | Select-Object -Property @(
        'Name'
        'Description'
        @{ Name = 'NetworkID'; Expression = 'SamAccountName' }
    ) | Export-csv "C:\temp\Group Audit\groups\$($Entry.Name).csv" -NoTypeInformation
}