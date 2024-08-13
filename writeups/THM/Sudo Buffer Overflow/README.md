
---

# sudo buffer overlow

`CVE-2019-18634`
affects versions of sudo earlier than 1.8.26.

IP = `10.10.39.121`

For this exploit we're more interested in one of the other options available: specifically an option called pwfeedback. This option is purely aesthetic, and is usually turned off by default (with the exception of ElementaryOS and Linux Mint - although they will likely now also stop using it). If you have used Linux before then you might have noticed that passwords typed into the terminal usually don't show any output at all; pwfeedback makes it so that whenever you type a character, an asterisk is displayed on the screen.

Here's the catch. When this option is turned on, it's possible to perform a buffer overflow attack on the sudo command. To explain it really simply, when a program accepts input from a user it stores the data in a set size of storage space. A buffer overflow attack is when you enter so much data into the input that it spills out of this storage space and into the next "box," overwriting the data in it. As far as we're concerned, this means if we fill the password box of the sudo command up with a lot of garbage, we can inject our own stuff in at the end. This could mean that we get a shell as root! This exploit works regardless of whether we have any sudo permissions to begin with, unlike in CVE-2019-14287 where we had to have a very specific set of permissions in the first place.

`https://github.com/saleemrashid/sudo-cve-2019-18634`

on remote

```
tryhackme@sudo-bof:~$ ./exploit
[sudo] password for tryhackme:
Sorry, try again.
#
```

got root

**/root/root.txt**

`THM{buff3r_0v3rfl0w_rul3s}`