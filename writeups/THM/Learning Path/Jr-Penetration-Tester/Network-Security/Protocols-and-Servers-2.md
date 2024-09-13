# Protocols and Servers 2

---

## Introduction


From a security perspective, we always need to think about what we aim to protect; consider the security triad: Confidentiality, Integrity, and Availability (CIA). Confidentiality refers to keeping the contents of the communications accessible to the intended parties. Integrity is the idea of assuring any data sent is accurate, consistent, and complete when reaching its destination. Finally, availability refers to being able to access the service when we need it. Different parties will put varying emphasis on these three. For instance, confidentiality would be the highest priority for an intelligence agency. Online banking will put most emphasis on the integrity of transactions. Availability is of the highest importance for any platform making money by serving ads.

Knowing that we are protecting the Confidentiality, Integrity, and Availability (CIA), an attack aims to cause Disclosure, Alteration, and Destruction (DAD). The figures below reflect this.
![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/992438a051d1355cf1146705557b457d.png)

---

## Sniffing Attack


- Sniffing attack refers to using a network packet capture tool to collect information about the target. 
- When a protocol communicates in cleartext, the data exchanged can be captured by a third party to analyse. A simple network packet capture can reveal information, such as the content of private messages and login credentials, if the data isn't encrypted in transit.

A sniffing attack can be conducted using an Ethernet (802.3) network card, provided that the user has proper permissions (root permissions on Linux and administrator privileges on MS Windows). There are many programs available to capture network packets. We consider the following:

   - Tcpdump is a free open source command-line interface (CLI) program that has been ported to work on many operating systems.
   - Wireshark is a free open source graphical user interface (GUI) program available for several operating systems, including Linux, macOS and MS Windows.
   - Tshark is a CLI alternative to Wireshark.


`sudo tcpdump port 110 -A`

We need sudo as packet captures require root privileges. We wanted to limit the number of captured and displayed packets to those exchanged with the POP3 server. We know that POP3 uses port 110, so we filtered our packets using port 110. Finally, we wanted to display the contents of the captured packets in ASCII format, so we added -A.

- In brief, any protocol that uses cleartext communication is susceptible to this kind of attack. 
- The only requirement for this attack to succeed is to have access to a system between the two communicating systems.

-This attack requires attention; the mitigation lies in adding an encryption layer on top of any network protocol. In particular, Transport Layer Security (TLS) has been added to HTTP, FTP, SMTP, POP3, IMAP and many others. For remote access, Telnet has been replaced by the secure alternative Secure Shell (SSH).

---

## Man-in-the-Middle (MITM) Attack


- A Man-in-the-Middle (MITM) attack occurs when a victim (A) believes they are communicating with a legitimate destination (B) but is unknowingly communicating with an attacker (E). 

In the figure below, we have A requesting the transfer of $20 to M; however, E altered this message and replaced the original value with a new one. B received the modified messaged and acted on it.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/3cb0c4f9dde184bf8dcd6b3a45418a44.png)

- This attack is relatively simple to carry out if the two parties do not confirm the authenticity and integrity of each message.
- In some cases, the chosen protocol does not provide secure authentication or integrity checking; moreover, some protocols have inherent insecurities that make them susceptible to this kind of attack.

Any time you browse over HTTP, you are susceptible to a MITM attack, and the scary thing is that you cannot recognize it. Many tools would aid you in carrying out such an attack, such as Ettercap and Bettercap.

MITM can also affect other cleartext protocols such as FTP, SMTP, and POP3. Mitigation against this attack requires the use of cryptography. The solution lies in proper authentication along with encryption or signing of the exchanged messages. With the help of Public Key Infrastructure (PKI) and trusted root certificates, Transport Layer Security (TLS) protects from MITM attacks.

---

## Transport Layer Security (TLS)


SSL (Secure Sockets Layer) started when the world wide web started to see new applications, such as online shopping and sending payment information. Netscape introduced SSL in 1994, with SSL 3.0 being released in 1996. But eventually, more security was needed, and TLS (Transport Layer Security) protocol was introduced in 1999. Before we explain what TLS and SSL provide, let’s see how they fit the networking model.

The common protocols we have covered so far send the data in cleartext; this makes it possible for anyone with access to the network to capture, save and analyze the exchanged messages. The image below shows the ISO/OSI network layers. The protocols we have covered so far in this room are on the application layer. Consider the ISO/OSI model; we can add encryption to our protocols via the presentation layer. Consequently, data will be presented in an encrypted format (ciphertext) instead of its original form.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/9d265987c58331f6fd2f664837f85380.png)


- Because of the close relation between SSL and TLS, one might be used instead of the other. However, TLS is more secure than SSL, and it has practically replaced SSL. 

An existing cleartext protocol can be upgraded to use encryption via SSL/TLS. We can use TLS to upgrade HTTP, FTP, SMTP, POP3, and IMAP, to name a few. The following table lists the protocols we have covered and their default ports before and after the encryption upgrade via SSL/TLS. The list is not exhaustive.

| Protocol | Default Port | Secured Protocol | Default Port with TLS |
| -------- | ------------ | ---------------- | --------------------- |
| HTTP     | 80           | HTTPS            | 443                   |
| FTP      | 21           | FTPS             | 990                   |
| SMTP     | 25           | SMTPS            | 465                   |
| POP3     | 110          | POP3S            | 995                   |
| IMAP     | 143          | IMAPS            | 993                   |


Considering the case of HTTP. Initially, to retrieve a web page over HTTP, the web browser would need at least perform the following two steps:

   1. Establish a TCP connection with the remote web server
   2. Send HTTP requests to the web server, such as GET and POST requests.

HTTPS requires an additional step to encrypt the traffic. The new step takes place after establishing a TCP connection and before sending HTTP requests. This extra step can be inferred from the ISO/OSI model in the image presented earlier. Consequently, HTTPS requires at least the following three steps:

   1. Establish a TCP connection
   2. Establish SSL/TLS connection
   3. Send HTTP requests to the webserver


To establish an SSL/TLS connection, the client needs to perform the proper handshake with the server. Based on RFC 6101, the SSL connection establishment will look like the figure below.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/ea654470ae699d10e9c07bd11a8320ac.png)

After establishing a TCP connection with the server, the client establishes an SSL/TLS connection, as shown in the figure above. The terms might look complicated depending on your knowledge of cryptography, but we can simplify the four steps as:

   1. The client sends a ClientHello to the server to indicate its capabilities, such as supported algorithms.
   2. The server responds with a ServerHello, indicating the selected connection parameters. The server provides its certificate if server authentication is required. The certificate is a digital file to identify itself; it is usually digitally signed by a third party. Moreover, it might send additional information necessary to generate the master key, in its ServerKeyExchange message, before sending the ServerHelloDone message to indicate that it is done with the negotiation.
   3. The client responds with a ClientKeyExchange, which contains additional information required to generate the master key. Furthermore, it switches to use encryption and informs the server using the ChangeCipherSpec message.
   4. The server switches to use encryption as well and informs the client in the ChangeCipherSpec message.

If this still sounds sophisticated, don’t worry; we only need the gist of it. A client was able to agree on a secret key with a server that has a public certificate. This secret key was securely generated so that a third party monitoring the channel wouldn’t be able to discover it. Further communication between the client and the server will be encrypted using the generated key.

Consequently, once an SSL/TLS handshake has been established, HTTP requests and exchanged data won’t be accessible to anyone watching the communication channel.

As a final note, for SSL/TLS to be effective, especially when browsing the web over HTTPS, we rely on public certificates signed by certificate authorities trusted by our systems. In other words, when we browse to TryHackMe over HTTPS, our browser expects the TryHackMe web server to provide a signed certificate from a trusted certificate authority, as per the example below. This way, our browser ensures that it is communicating with the correct server, and a MITM attack cannot occur.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/2362c08e3a718863a1b1b56279931538.png)

In the figure above, we can see the following information:

   1. To whom is the certificate issued? That is the name of the company that will use this certificate.
   2. Who issued the certificate? This is the certificate authority that issued this certificate.
   3. Validity period. You don’t want to use a certificate that has expired, for instance.

---

## Secure Shell (SSH)


- Secure Shell (SSH) was created to provide a secure way for remote system administration. In other words, it lets you securely connect to another system over the network and execute commands on the remote system.


   1. You can confirm the identity of the remote server
   2. Exchanged messages are encrypted and can only be decrypted by the intended recipient
   3. Both sides can detect any modification in the messages


- To use SSH, you need an SSH server and an SSH client. The SSH server listens on port 22 by default. The SSH client can authenticate using:

  - A username and a password
  - A private and public key (after the SSH server is configured to recognize the corresponding public key)


`ssh username@MACHINE_IP`

- SSH is very reliable for remote administration because our username and password were sent encrypted; moreover, all commands we execute on the remote system will be sent over an encrypted channel.
- Note that if this is the first time we connect to this system, we will need to confirm the fingerprint of the SSH server’s public key to avoid man-in-the-middle (MITM) attacks. 
- In the case of SSH, we don’t usually have a third party to check if the public key is valid, so we need to do this manually. 

- We can use SSH to transfer files using SCP (Secure Copy Protocol) based on the SSH protocol. An example of the syntax is as follows: `scp mark@MACHINE_IP:/home/mark/archive.tar.gz ~`.

- As a closing note, FTP could be secured using SSL/TLS by using the FTPS protocol which uses port 990. It is worth mentioning that FTP can also be secured using the SSH protocol which is the SFTP protocol. By default this service listens on port 22, just like SSH.

---

## Password Attack


Authentication, or proving your identity, can be achieved through one of the following, or a combination of two:

   1. Something you know, such as password and PIN code.
   2. Something you have, such as a SIM card, RFID card, and USB dongle.
   3. Something you are, such as fingerprint and iris.

Attacks against passwords are usually carried out by:

   1. Password Guessing: Guessing a password requires some knowledge of the target, such as their pet’s name and birth year.
   2. Dictionary Attack: This approach expands on password guessing and attempts to include all valid words in a dictionary or a wordlist.
   3. Brute Force Attack: This attack is the most exhaustive and time-consuming where an attacker can go as far as trying all possible character combinations, which grows fast (exponential growth with the number of characters).

**Tools**:

Hydra:

`hydra -l username -P wordlist.txt server service`

`hydra -l mark -P /usr/share/wordlists/rockyou.txt MACHINE_IP ftp`
`hydra -l mark -P /usr/share/wordlists/rockyou.txt ftp://MACHINE_IP`
`hydra -l lazie -P /usr/share/wordlists/rockyou.txt imap://MACHINE_IP`

There are some extra optional arguments that you can add:

   - -s PORT to specify a non-default port for the service in question.
   - -V or -vV, for verbose, makes Hydra show the username and password combinations that are being tried. This verbosity is very convenient to see the progress, especially if you are still not confident of your command-line syntax.
   - -t n where n is the number of parallel connections to the target. -t 16 will create 16 threads used to connect to the target.
   - -d, for debugging, to get more detailed information about what’s going on. The debugging output can save you much frustration; for instance, if Hydra tries to connect to a closed port and timing out, -d will reveal this right away.

Mitigation against such attacks can be sophisticated and depends on the target system. A few of the approaches include:

   - Password Policy: Enforces minimum complexity constraints on the passwords set by the user.
   - Account Lockout: Locks the account after a certain number of failed attempts.
   - Throttling Authentication Attempts: Delays the response to a login attempt. A couple of seconds of delay is tolerable for someone who knows the password, but they can severely hinder automated tools.
   - Using CAPTCHA: Requires solving a question difficult for machines. It works well if the login page is via a graphical user interface (GUI). (Note that CAPTCHA stands for Completely Automated Public Turing test to tell Computers and Humans Apart.)
   - Requiring the use of a public certificate for authentication. This approach works well with SSH, for instance.
   - Two-Factor Authentication: Ask the user to provide a code available via other means, such as email, smartphone app or SMS.
   - There are many other approaches that are more sophisticated or might require some established knowledge about the user, such as IP-based geolocation.

Using a combination of the above approaches is an excellent approach to protect against password attacks.

---

## Summary


Three common attacks are:

   - Sniffing Attack
   - MITM Attack
   - Password Attack

Ports:

| Protocol | TCP Port | Application(s)                  | Data Security |
| -------- | -------- | ------------------------------- | ------------- |
| FTP      | 21       | File Transfer                   | Cleartext     |
| FTPS     | 990      | File Transfer                   | Encrypted     |
| HTTP     | 80       | Worldwide Web                   | Cleartext     |
| HTTPS    | 443      | Worldwide Web                   | Encrypted     |
| IMAP     | 143      | Email (MDA)                     | Cleartext     |
| IMAPS    | 993      | Email (MDA)                     | Encrypted     |
| POP3     | 110      | Email (MDA)                     | Cleartext     |
| POP3S    | 995      | Email (MDA)                     | Encrypted     |
| SFTP     | 22       | File Transfer                   | Encrypted     |
| SSH      | 22       | Remote Access and File Transfer | Encrypted     |
| SMTP     | 25       | Email (MTA)                     | Cleartext     |
| SMTPS    | 465      | Email (MTA)                     | Encrypted     |
| Telnet   | 23       | Remote Access                   | Cleartext     |

Hydra:

| Option            | Explanation                                                   |
| ----------------- | ------------------------------------------------------------- |
| `-l username`     | Provide the login name                                        |
| `-P WordList.txt` | Specify the password list to use                              |
| `server service`  | Set the server address and service to attack                  |
| `-s PORT`         | Use in case of non-default service port number                |
| `-V` or `-vV`     | Show the username and password combinations being tried       |
| `-d`              | Display debugging output if the verbose output is not helping |