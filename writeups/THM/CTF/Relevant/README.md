# Relevant

---

IP = `10.10.89.151`

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
└─# smbclient -NL 10.10.89.151

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
└─# smbclient -N //10.10.89.151/nt4wrksv
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

http://10.10.63.69:49663/nt4wrksv/passwords.txt