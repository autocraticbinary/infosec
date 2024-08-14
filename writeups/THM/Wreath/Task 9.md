
---

1. What is the absolute path to the file containing DNS entries on Linux?

`/etc/resolv.conf`

2. What is the absolute path to the hosts file on Windows?

`C:\Windows\System32\drivers\etc\hosts`

3. How could you see which IP addresses are active and allow ICMP echo requests on the 172.16.0.x/24 network using Bash?

`for i in {seq 1..255}; do (ping -c 1 172.16.0.${i} | grep "bytes from" &); done`

