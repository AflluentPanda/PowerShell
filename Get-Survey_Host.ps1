<#
    .SYNOPSIS  
        Surveys a workstation OS in order to get a holisitc view of the system's use and purpose.


    ####################################################################################


#>

$IP = Read-Host 'Enter IP:'

echo "          Running scan against $($IP)" | Out-File .\$IP.txt -encoding ASCII -width 5000
echo "`n" | ac .\$IP.txt

echo "          $(date)" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                     CURRENT USER                   ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
quser | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                    OS DETAILS                      ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
systeminfo | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
nbtstat -n | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                       IPCONFIG                     ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
ipconfig /all | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                   PROCESS ANALYSIS                 ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "############                PROCESS LIST WITH DLLs              ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
tasklist /m | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############              PROCESS LIST WITH SERVICES            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
tasklist /svc | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############          PROCESS LIST WITH CMD LINE OPTIONS        ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
Get-WmiObject Win32_Process | select name, CommandLine | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                  PROCESS LIST TREE                 ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo $($ProcessesById = @{}
    foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
      $ProcessesById[$Process.ProcessId] = $Process
    }
    
    $ProcessesWithoutParents = @()
    $ProcessesByParent = @{}
    foreach ($Pair in $ProcessesById.GetEnumerator()) {
      $Process = $Pair.Value
    
      if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
        $ProcessesWithoutParents += $Process
        continue
      }
    
      if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
        $ProcessesByParent[$Process.ParentProcessId] = @()
      }
      $Siblings = $ProcessesByParent[$Process.ParentProcessId]
      $Siblings += $Process
      $ProcessesByParent[$Process.ParentProcessId] = $Siblings
    }

    function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
      $Process = $ProcessesById[$ProcessId]
      $Indent = " " * $IndentLevel
      if ($Process.CommandLine) {
        $Description = $Process.CommandLine
      } else {
        $Description = $Process.Caption
      }
    
      Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
      foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
        Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
      }
    }

    Write-Output ("{0,6} {1}" -f "PID", "Command Line")
    Write-Output ("{0,6} {1}" -f "---", "------------")
    
    foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
      Show-ProcessTree $Process.ProcessId 0
    }) | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
    
    
echo "############################################################################" | ac .\$IP.txt
echo "############                PREFETCH DIRECTORY                  ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
dir c:\windows\prefetch | sort name | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                     SERVICES                       ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
Get-Service | Format-List | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############           NETWORK INTERFACE INFORMATION            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
get-wmiobject win32_networkadapter | select netconnectionid, name, InterfaceIndex, netconnectionstatus | Format-List | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############    LISTENING PORTS AND ESTABLISHED CONNECTIONS     ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
netstat -anob | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

            echo "############################################################################" | ac .\$IP.txt
            echo "############           IS THE NIC IN PROMISCOUS MODE?           ############" | ac .\$IP.txt
            echo "############################################################################" | ac .\$IP.txt
            echo "`n" | ac .\$IP.txt
            Get-NetAdapter | Format-List -Property PromiscuousMode | ac .\$IP.txt
            echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############               NETWORK ROUTING INFO                 ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
route print | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############         NETWORKS IN NETWORK LIST PROFILES          ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" /s | ac .\$IP.txt 
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############         NETWORKS IN NETWORK LIST PROFILES          ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
get-wmiobject win32_networkadapter | select netconnectionid, name, InterfaceIndex, netconnectionstatus | Format-List | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                CURRENT DNS CACHE                   ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
ipconfig /displaydns | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                       ARP                          ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
arp -a | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                 NETWORK SHARES                     ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net share | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net use | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############    VIEW AVAILABLE WIRELESS NETWORKS IN THE AREA    ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
netsh wlan show networks | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############       DEFAULT GATEWAY MAC FOR NET PROFILES         ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Managed" /s | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############         COMPUTERS IN WORKGROUP OR DOMAIN           ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net view | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                   USER ACCOUNTS                    ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                LOCAL USER ACCOUNTS                 ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net user | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                    LOCAL GROUPS                    ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net localgroup | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############          USERS BELONGING TO ADMIN GROUP            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
net localgroup administrators | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                DRIVE INFORMATION                  ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
Get-PSDrive | Format-List
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                  SOFTWARE KEY                      ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\Software" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############           VALUE IN LOCAL MACHINE RUN KEY           ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############         VALUE IN LOCAL MACHINE RUNONCE KEY         ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Runonce" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############           VALUE IN CURRENT USER RUN KEY            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############         VALUE IN CURRENT USER RUNONCE KEY          ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                AUTOSTART LOCATIONS                 ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo $(Get-WmiObject Win32_Service | Format-Table -AutoSize) | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############              CHECKING IE INFORMATION               ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKCU\Software\Microsoft\Internet Explorer" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############           CHECKING USER'S IE START PAGE            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############           CHECKING USER'S IE TYPED URLS            ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKCU\Software\Microsoft\Internet Explorer\TypedURLs" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############              FIREWALL CONFIGURATIONS               ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
netsh advfirewall show allprofiles | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
reg query "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\Logging" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

echo "############################################################################" | ac .\$IP.txt
echo "############                  SCHEDULED TASKS                   ############" | ac .\$IP.txt
echo "############################################################################" | ac .\$IP.txt
echo "`n" | ac .\$IP.txt
schtasks /query /v | ac .\$IP.txt
echo "`n" | ac .\$IP.txt

