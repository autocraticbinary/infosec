# Passive Reconnaissance

---

## Introduction


- `whois` to query WHOIS servers
- `nslookup` to query DNS servers
- `dig` to query DNS servers

---

## Passive VS Active Recon


- Reconnaissance (recon) can be defined as a preliminary survey to gather information about a target. 

- Two types:
	- Passive Recon
	- Active Recon

**Passive Recon**

In passive reconnaissance, you rely on publicly available knowledge. It is the knowledge that you can access from publicly available resources without directly engaging with the target. 

Passive reconnaissance activities include many activities, for instance:

- Looking up DNS records of a domain from a public server.
- Checking job ads related to the target website.
- Reading news articles about the target company.

**Active Recon**:

Active reconnaissance, on the other hand, cannot be achieved so discreetly. It requires direct engagement with the target. 

Examples of active reconnaissance activities include:

- Connecting to one of the company servers such as HTTP, FTP, and SMTP.
- Calling the company in an attempt to get information (social engineering).
- Entering company premises pretending to be a repairman.

---

## WHOIS


- WHOIS is a request and response protocol that follows the RFC 3912 specification.
- A WHOIS server listens on TCP port 43 for incoming requests.
- The domain registrar is responsible for maintaining the WHOIS records for the domain names it is leasing. - The WHOIS server replies with various information related to the domain requested.

Of particular interest, we can learn:

    - Registrar: Via which registrar was the domain name registered?
    - Contact info of registrant: Name, organization, address, phone, among other things. (unless made hidden via a privacy service)
    - Creation, update, and expiration dates: When was the domain name first registered? When was it last updated? And when does it need to be renewed?
    - Name Server: Which server to ask to resolve the domain name?

`whois DOMAIN_NAME`

---

## NSLOOKUP & DIG


### NSLOOKUP

- Find the IP address of a domain name using `nslookup`, which stands for Name Server Look Up.

`nslookup DOMAIN_NAME`

Or, more generally, you can use nslookup OPTIONS DOMAIN_NAME SERVER. These three main parameters are:

- OPTIONS contains the query type as shown in table below. For instance, you can use `A` for Iaddresses and `AAAA` for IPv6 addresses.
- DOMAIN_NAME is the domain name you are looking up.
- SERVER is the DNS server that you want to queYou can choose any local or public DNS serverquery. Cloudflare offers `1.1.1.1` and `1.0.0.1`, Google offers `8.8.8.8` and `8.8.4.4`, and Quoffers `9.9.9.9` and `149.112.112.112`. There are more [public DNS servers](https://duckduckgo.com/?q=public+dns) that you can choose from if you want alternatives to your ISP’s DNS servers.

| Query type | Result             |
| ---------- | ------------------ |
| A          | IPv4 Addresses     |
| AAAA       | IPv6 Addresses     |
| CNAME      | Canonical Name     |
| MX         | Mail Servers       |
| SOA        | Start of Authority |
| TXT        | TXT Records        |


Example:

1. For instance, `nslookup -type=A tryhackme.com 1.1.1.1` (or `nslookup -type=a tryhackme.com 1.1.1.1` as it is case-insensitive) can be used to return all the IPv4 addresses used by tryhackme.com.

```
user@TryHackMe$ nslookup -type=A tryhackme.com 1.1.1.1
Server:		1.1.1.1
Address:	1.1.1.1#53

Non-authoritative answer:
Name:	tryhackme.com
Address: 172.67.69.208
Name:	tryhackme.com
Address: 104.26.11.229
Name:	tryhackme.com
Address: 104.26.10.229
```
2. `nslookup -type=MX tryhackme.com`

```  
user@TryHackMe$ nslookup -type=MX tryhackme.com
Server:		127.0.0.53
Address:	127.0.0.53#53

Non-authoritative answer:
tryhackme.com	mail exchanger = 5 alt1.aspmx.l.google.com.
tryhackme.com	mail exchanger = 1 aspmx.l.google.com.
tryhackme.com	mail exchanger = 10 alt4.aspmx.l.google.com.
tryhackme.com	mail exchanger = 10 alt3.aspmx.l.google.com.
tryhackme.com	mail exchanger = 5 alt2.aspmx.l.google.com.
```

Since MX is looking up the Mail Exchange servers, we notice that when a mail server tries to deliver email `@tryhackme.com`, it will try to connect to the `aspmx.l.google.com`, which has order 1. If it is busy or unavailable, the mail server will attempt to connect to the next in order mail exchange servers, `alt1.aspmx.l.google.com` or `alt2.aspmx.l.google.com`.


### DIG

- For more advanced DNS queries and additional functionality, you can use `dig`, the acronym for “Domain Information Groper”.

`dig DOMAIN_NAME`

specify the record type:
`dig DOMAIN_NAME TYPE`

select the server:
`dig @SERVER DOMAIN_NAME TYPE`


- SERVER is the DNS server that you want to query.
- DOMAIN_NAME is the domain name you are looking up.
- TYPE contains the DNS record type, as shown in the table provided earlier.

---

## DNSDumpster


- DNS lookup tools, such as nslookup and dig, cannot find subdomains on their own. 

- https://dnsdumpster.com/

---

## Shodan.io


- https://www.shodan.io/

Shodan.io tries to connect to every device reachable online to build a search engine of connected “things” in contrast with a search engine for web pages. Once it gets a response, it collects all the information related to the service and saves it in the database to make it searchable.

- Via this Shodan.io search result, we can learn
    - IP address
    - hosting company
    - geographic location
    - server type and version

- You may also try searching for the IP addresses you have obtained from DNS lookups.