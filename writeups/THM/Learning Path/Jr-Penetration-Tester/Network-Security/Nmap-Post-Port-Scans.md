# Nmap Post Port Scans

---

## Service Detection


- Adding `-sV` to your Nmap command will collect and determine service and version information for the open ports. You can control the intensity with `--version-intensity LEVEL` where the level ranges between 0, the lightest, and 9, the most complete. `-sV --version-light` has an intensity of 2, while `-sV --version-all` has an intensity of 9. 

- It is important to note that using `-sV` will force Nmap to proceed with the TCP 3-way handshake and establish the connection. 
- The connection establishment is necessary because Nmap cannot discover the version without establishing a connection fully and communicating with the listening service. In other words, stealth SYN scan -sS is not possible when -sV option is chosen. 

---

## OS Detection and Traceroute


## OS Detection

- Nmap can detect the Operating System (OS) based on its behaviour and any telltale signs in its responses. OS detection can be enabled using `-O`.

`nmap -sS -O TARGET_IP`

The OS detection is very convenient, but many factors might affect its accuracy. First and foremost, Nmap needs to find at least one open and one closed port on the target to make a reliable guess. Furthermore, the guest OS fingerprints might get distorted due to the rising use of virtualization and similar technologies. Therefore, always take the OS version with a grain of salt.


## Traceroute

- If you want Nmap to find the routers between you and the target, just add `--traceroute`.

Note that Nmap’s traceroute works slightly different than the traceroute command found on Linux and macOS or tracert found on MS Windows. Standard traceroute starts with a packet of low TTL (Time to Live) and keeps increasing until it reaches the target. Nmap’s traceroute starts with a packet of high TTL and keeps decreasing it.  

`nmap -sS --traceroute TARGET_IP`

- It is worth mentioning that many routers are configured not to send ICMP Time-to-Live exceeded, which would prevent us from discovering their IP addresses. 

---

## Nmap Scripting Engine (NSE)


- located at `/usr/share/nmap/scripts`
- You can choose to run the scripts in the default category using `--script=default` or simply adding `-sC`.
- In addition to default, categories include auth, broadcast, brute, default, discovery, dos, exploit, external, fuzzer, intrusive, malware, safe, version, and vuln.

| Script Category | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| `auth`          | Authentication related scripts                                         |
| `broadcast`     | Discover hosts by sending broadcast messages                           |
| `brute`         | Performs brute-force password auditing against logins                  |
| `default`       | Default scripts, same as `-sC`                                         |
| `discovery`     | Retrieve accessible information, such as database tables and DNS names |
| `dos`           | Detects servers vulnerable to Denial of Service (DoS)                  |
| `exploit`       | Attempts to exploit various vulnerable services                        |
| `external`      | Checks using a third-party service, such as Geoplugin and Virustotal   |
| `fuzzer`        | Launch fuzzing attacks                                                 |
| `intrusive`     | Intrusive scripts such as brute-force attacks and exploitation         |
| `malware`       | Scans for backdoors                                                    |
| `safe`          | Safe scripts that won’t crash the target                               |
| `version`       | Retrieve service versions                                              |
| `vuln`          | Checks for vulnerabilities or exploit vulnerable services              |

- You can also specify the script by name using `--script "SCRIPT-NAME"` or a pattern such as `--script "ftp*"`.

---

## Saving the Output


The three main formats are:

   1. Normal
   2. Grepable (`grep`able)
   3. XML

**Normal**:

`-oN FILENAME`

**Grepable**:

`-oG FILENAME`

- An example use of grep is grep KEYWORD TEXT_FILE; this command will display all the lines containing the provided keyword.

**XML**:

`-oX FILENAME`

- You can save the scan output in all three formats using -oA FILENAME to combine -oN, -oG, and -oX for normal, grepable, and XML. 

**Script Kiddie**:

`nmap -sS 127.0.0.1 -oS FILENAME`

---

## Summary


| Option                      | Meaning                                         |
| --------------------------- | ----------------------------------------------- |
| `-sV`                       | determine service/version info on open ports    |
| `-sV --version-light`       | try the most likely probes (2)                  |
| `-sV --version-all`         | try all available probes (9)                    |
| `-O`                        | detect OS                                       |
| `--traceroute`              | run traceroute to target                        |
| `--script=SCRIPTS`          | Nmap scripts to run                             |
| `-sC` or `--script=default` | run default scripts                             |
| `-A`                        | equivalent to `-sV -O -sC --traceroute`         |
| `-oN`                       | save output in normal format                    |
| `-oG`                       | save output in grepable format                  |
| `-oX`                       | save output in XML format                       |
| `-oA`                       | save output in normal, XML and Grepable formats |