#### Gets DNS data using WMI in Server 2008. In Server 2012, there is are DNS cmdlets that make this task much easier.


# All Records (Server 08)
get-wmiobject -Namespace root\MicrosoftDNS -class microsoftdns_resourcerecord | select __Class, ContainerName, DomainName, RecordData, ownername | out-gridview

# Gets Roothints (Server 08)
get-wmiobject -Namespace root\MicrosoftDNS -class microsoftdns_resourcerecord | where{$_.domainname -eq "..roothints"} | out-gridview

# Gets Zones (Server 2008)
Get-WmiObject -namespace "root\MicrosoftDNS" -class MicrosoftDNS_Zone | select Name

# Stats
 get-wmiobject -Namespace root\MicrosoftDNS -class microsoftdns_statistic | select name, value |out-gridview