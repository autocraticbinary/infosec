
---

### Task 1

```
chmod +x crackme1
./crackme1
```

> flag{not_that_kind_of_elf}

### Task 2

```
┌──(root㉿core)-[/work]
└─# ./crackme
bash: ./crackme: No such file or directory

┌──(root㉿core)-[/work]
└─# ./crackme2
Usage: ./crackme2 password

┌──(root㉿core)-[/work]
└─# ./crackme2 test
Access denied.

┌──(root㉿core)-[/work]
└─# ltrace ./crackme2 test
__libc_start_main([ "./crackme2", "test" ] <unfinished ...>
strcmp("test", "super_secret_password")                                                                              = 1
puts("Access denied."Access denied.
)                                                                                               = 15
+++ exited (status 1) +++

┌──(root㉿core)-[/work]
└─# ./crackme2 super_secret_password
Access granted.
flag{if_i_submit_this_flag_then_i_will_get_points}
```

> flag{if_i_submit_this_flag_then_i_will_get_points}

### Task 3

```
┌──(root㉿core)-[/work]
└─# strings crackme3
--SNIP--
Usage: %s PASSWORD
malloc failed
ZjByX3kwdXJfNWVjMG5kX2xlNTVvbl91bmJhc2U2NF80bGxfN2gzXzdoMW5nNQ==
Correct password!
--SNIP--

┌──(root㉿core)-[/work]
└─# echo "ZjByX3kwdXJfNWVjMG5kX2xlNTVvbl91bmJhc2U2NF80bGxfN2gzXzdoMW5nNQ==" | base64 -d
f0r_y0ur_5ec0nd_le55on_unbase64_4ll_7h3_7h1ng5
┌──(root㉿core)-[/work]
└─#
```

> f0r_y0ur_5ec0nd_le55on_unbase64_4ll_7h3_7h1ng5

### Task 4

```
┌──(root㉿core)-[/work]
└─# ./crackme4
Usage : ./crackme4 password
This time the string is hidden and we used strcmp

┌──(root㉿core)-[/work]
└─# ./crackme4 test
password "test" not OK

┌──(root㉿core)-[/work]
└─# ltrace ./crackme4 test
__libc_start_main([ "./crackme4", "test" ] <unfinished ...>
strcmp("my_m0r3_secur3_pwd", "test")                                                                                 = -7
printf("password "%s" not OK\n", "test"password "test" not OK
)                                                                             = 23
+++ exited (status 0) +++

┌──(root㉿core)-[/work]
└─# ./crackme4 my_m0r3_secur3_pwd
password OK
```

> my_m0r3_secur3_pwd

### Task 5

```
[farco@core sec]$ ./crackme5
Enter your input:
test
Always dig deeper
[farco@core sec]$ ltrace ./crackme5
__libc_start_main(0x400773, 1, 0x7fff8f89be88, 0x4008d0 <unfinished ...>
puts("Enter your input:"Enter your input:
)                                                                                            = 18
__isoc99_scanf(0x400966, 0x7fff8f89bd20, 0, 0x7827e91727d4test
)                                                          = 1
strlen("test")                                                                                                       = 4
strlen("test")                                                                                                       = 4
strlen("test")                                                                                                       = 4
strlen("test")                                                                                                       = 4
strlen("test")                                                                                                       = 4
strncmp("test", "OfdlDSA|3tXb32~X3tX@sX`4tXtz'x", 28)                                                                = 37
puts("Always dig deeper"Always dig deeper
)                                                                                            = 18
+++ exited (status 0) +++
[farco@core sec]$ ./crackme5
Enter your input:
OfdlDSA|3tXb32~X3tX@sX`4tXtz'x
Good game
[farco@core sec]$
```

> OfdlDSA|3tXb32~X3tX@sX`4tXtzzv

### Task 6

