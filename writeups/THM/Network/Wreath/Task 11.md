
---

1. If you're connecting to an SSH server _from_ your attacking machine to create a port forward, would this be a local (L) port forward or a remote (R) port forward?

`L`

2. Which switch combination can be used to background an SSH port forward or tunnel?

`-fN`

3. It's a good idea to enter our own password on the remote machine to set up a reverse proxy, Aye or Nay?

`Nay`

4. What command would you use to create a pair of throwaway SSH keys for a reverse connection?

`ssh-keygen`

5. If you wanted to set up a reverse portforward from port 22 of a remote machine (172.16.0.100) to port 2222 of your local machine (172.16.0.200), using a keyfile called `id_rsa` and backgrounding the shell, what command would you use? (Assume your username is "kali")

`ssh -R 2222:172.16.0.100:22 kali@172.16.0.200 -i id_rsa -fN`

6. What command would you use to set up a forward proxy on port 8000 to user@target.thm, backgrounding the shell?

`ssh -D 8000 user@target.thm -fN`

7. If you had SSH access to a server (172.16.0.50) with a webserver running internally on port 80 (i.e. only accessible to the server itself on 127.0.0.1:80), how would you forward it to port 8000 on your attacking machine? Assume the username is "user", and background the shell.

`ssh -L 8000:127.0.0.1:80 user@172.16.0.50 -fN`