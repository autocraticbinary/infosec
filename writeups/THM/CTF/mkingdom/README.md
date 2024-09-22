# mKingdom

---

## nmap

```
PORT   STATE SERVICE VERSION
85/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
```

## directory enumeration

`/app                  (Status: 301) [Size: 310] [--> http://10.10.25.34:85/app/]`

`/castle               (Status: 301) [Size: 317] [--> http://10.10.25.34:85/app/castle/]`

```
[13:38:33] 301 -  329B  - /app/castle/application  ->  http://10.10.25.34:85/app/castle/application/
[13:38:33] 200 -    0B  - /app/castle/application/
[13:38:50] 200 -    2KB - /app/castle/composer.json
[13:38:56] 200 -  270KB - /app/castle/composer.lock
[13:39:25] 301 -  436B  - /app/castle/index.php/login/  ->  http://10.10.25.34:85/app/castle/index.php/login
[13:40:18] 200 -  175B  - /app/castle/robots.txt
[13:40:52] 301 -  325B  - /app/castle/updates  ->  http://10.10.25.34:85/app/castle/updates/
```