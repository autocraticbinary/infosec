# Subdomain Enumeration


- Subdomain enumeration is the process of finding valid subdomains for a domain
- We do this to expand our attack surface to try and discover more potential points of vulnerability.

- Let's explore three different subdomain enumeration methods:
	- Brute Force
	- OSINT (Open-Source Intelligence) and
	- Virtual Host.

## OSINT

### SSL/TLS Certificates

- When an SSL/TLS (Secure Sockets Layer/Transport Layer Security) certificate is created for a domain by a CA (Certificate Authority), CA's take part in what's called "Certificate Transparency (CT) logs". 
- CT Logs are publicly accessible logs of every SSL/TLS certificate created for a domain name.
- The purpose of Certificate Transparency logs is to stop malicious and accidentally made certificates from being used.
- We can use this service to our advantage to discover subdomains belonging to a domain, sites like https://crt.sh and https://ui.ctsearch.entrust.com/ui/ctsearchui offer a searchable database of certificates that shows current and historical results.


### Search Engines

Search engines contain trillions of links to more than a billion websites, which can be an excellent resource for finding new subdomains. Using advanced search methods on websites like Google, such as the site: filter, can narrow the search results.

For example,
`site:*.domain.com -site:www.domain.com`

would only contain results leading to the domain name domain.com but exclude any links to www.domain.com; therefore, it shows us only subdomain names belonging to domain.com.


### Sublist3r

To speed up the process of OSINT subdomain discovery, we can automate the above methods with the help of tools like Sublist3r

`./sublist3r.py -d acmeitsupport.thm`

---

## Brute Force

### DNS Bruteforce

Bruteforce DNS (Domain Name System) enumeration is the method of trying tens, hundreds, thousands or even millions of different possible subdomains from a pre-defined list of commonly used subdomains.

**Tool**:
	dnsrecon

`dnsrecon -t brt -d acmeitsupport.thm`

---

## Virtual Hosts

- Some subdomains aren't always hosted in publically accessible DNS results, such as development versions of a web application or administration portals.
- Instead, the DNS record could be kept on a private DNS server or recorded on the developer's machines in their /etc/hosts file (or c:\windows\system32\drivers\etc\hosts file for Windows users) which maps domain names to IP addresses. 


- Because web servers can host multiple websites from one server when a website is requested from a client, the server knows which website the client wants from the Host header. We can utilise this host header by making changes to it and monitoring the response to see if we've discovered a new website.

```
user@machine$ ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/namelist.txt -H "Host: FUZZ.acmeitsupport.thm" -u http://MACHINE_IP
```

```
user@machine$ ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/namelist.txt -H "Host: FUZZ.acmeitsupport.thm" -u http://MACHINE_IP -fs {size}
```

- -w : wordlists
- -H : adds/edit header
- -fs : ignore any results that are of the specified size.

example:

`ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/namelist.txt -H "Host: FUZZ.acmeitsupport.thm" -u http://10.10.248.77`

```
--SNIP--
delta                   [Status: 200, Size: 51, Words: 7, Lines: 1]
--SNIP--
yellow                  [Status: 200, Size: 56, Words: 8, Lines: 1]
--SNIP--
zebra                   [Status: 200, Size: 2395, Words: 503, Lines: 52]
```

`ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/namelist.txt -H "Host: FUZZ.acmeitsupport.thm" -u http://10.10.248.77 -fs 2395`

```
delta                   [Status: 200, Size: 51, Words: 7, Lines: 1]
yellow                  [Status: 200, Size: 56, Words: 8, Lines: 1]
```