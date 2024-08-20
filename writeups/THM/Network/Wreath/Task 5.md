
---

IP = `10.200.154.200`

1. How many of the first 15000 ports are open on the target?
`4`

`nmap -p 1-15000 --open 10.200.154.200 -oN nmap/initial`
```
PORT      STATE SERVICE  VERSION
22/tcp    open  ssh      OpenSSH 8.0 (protocol 2.0)
80/tcp    open  http     Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
443/tcp   open  ssl/http Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
10000/tcp open  http     MiniServ 1.890 (Webmin httpd)
```

2. What OS does Nmap think is running?
`centos`

3. Open the IP in your browser -- what site does the server try to redirect you to?
`https://thomaswreath.thm`

4. Read through the text on the page. What is Thomas' mobile phone number?
`+447821548812`

5. Look back at your service scan results: what server version does Nmap detect as running here?
`MiniServ 1.890 (Webmin httpd)`

6. What is the CVE number for this exploit?
`CVE-2019-15107`



