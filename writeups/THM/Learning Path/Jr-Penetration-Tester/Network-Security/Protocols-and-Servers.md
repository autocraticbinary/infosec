# Protocols and Servers

---

## Telnet


- The Telnet protocol is an application layer protocol used to connect to a virtual terminal of another computer. 
- Using Telnet, a user can log into another computer and access its terminal (console) to run programs, start batch processes, and perform system administration tasks remotely.

- All this communication between the Telnet client and the Telnet server is not encrypted, making it an easy target for attackers.
- A Telnet server uses the Telnet protocol to listen for incoming connections on port 23. 

`telnet MACHINE_IP`

A user is connecting to the telnetd, a Telnet server. The steps are as follows:

   1. First, he is asked to provide his login name (username). We can see the user entering `frank`.
   2. Then, he is asked for the password, `D2xc9CgD`. The password is not shown on the screen; however, we display it below for demonstration purposes.
   3. Once the system checks his login credentials, he is greeted with a welcome message.
   4. And the remote server grants him a command prompt, `frank@bento:~$`. The $ indicates that this is not a root terminal.


---

## Hypertext Transfer Protocol (HTTP)


- Hypertext Transfer Protocol (HTTP) is the protocol used to transfer web pages.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/a23a13cef49ae7fff87bfd94f6a175dc.png)

HTTP sends and receives data as cleartext (not encrypted); therefore, you can use a simple tool, such as Telnet (or Netcat), to communicate with a web server and act as a “web browser”. The key difference is that you need to input the HTTP-related commands instead of the web browser doing that for you.

- To use telnet instead of a web browser to request a file from the webserver. The steps will be as follows:

   1. First, we connect to port 80 using `telnet MACHINE_IP 80`.
   2. Next, we need to type `GET /index.html HTTP/1.1` to retrieve the page index.html or `GET / HTTP/1.1` to retrieve the default page.
   3. Finally, you need to provide some value for the host like `host: telnet` and press the Enter/Return key twice.

- We need an HTTP server (webserver) and an HTTP client (web browser) to use the HTTP protocol. The web server will “serve” a specific set of files to the requesting web browser.

- Three popular choices for HTTP servers are:

   - Apache
   - Internet Information Services (IIS)
   - nginx

---

## File Transfer Protocol (FTP)


- File Transfer Protocol (FTP) was developed to make the transfer of files between different computers with different systems efficient.
- FTP also sends and receives data as cleartext; therefore, we can use Telnet (or Netcat) to communicate with an FTP server and act as an FTP client.

In the example below, we carried out the following steps:

   1. We connected to an FTP server using a Telnet client. Since FTP servers listen on port 21 by default, we had to specify to our Telnet client to attempt connection to port 21 instead of the default Telnet port.
   2. We needed to provide the username with the command `USER frank`.
   3. Then, we provided the password with the command `PASS D2xc9CgD`.
   4. Because we supplied the correct username and password, we got logged in.

- A command like `STAT` can provide some added information.
- The `SYST` command shows the System Type of the target (UNIX in this case).
- `PASV` switches the mode to passive. It is worth noting that there are two modes for FTP:
    - Active: In the active mode, the data is sent over a separate channel originating from the FTP server’s port 20.
    - Passive: In the passive mode, the data is sent over a separate channel originating from an FTP client’s port above port number 1023.

- The command `TYPE A` switches the file transfer mode to ASCII, while `TYPE I` switches the file transfer mode to binary.
- However, we cannot transfer a file using a simple client such as Telnet because FTP creates a separate connection for file transfer.

The image below shows how an actual file transfer would be conducted using FTP. To keep things simple in this figure, let’s only focus on the fact that the FTP client will initiate a connection to an FTP server, which listens on port 21 by default. All commands will be sent over the control channel. Once the client requests a file, another TCP connection will be established between them. (The details of establishing the data connection/channel is beyond the scope of this room.)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/da71a52fddfbb268dc6c5857daf07f18.png)

- FTP servers and FTP clients use the FTP protocol. There are various FTP server software that you can select from if you want to host your FTP file server. Examples of FTP server software include:

   - vsftpd
   - ProFTPD
   - uFTP

- For FTP clients, in addition to the console FTP client commonly found on Linux systems, you can use an FTP client with GUI such as FileZilla. Some web browsers also support FTP protocol.

- Because FTP sends the login credentials along with the commands and files in cleartext, FTP traffic can be an easy target for attackers.

---

## Simple Mail Transfer Protocol (SMTP)


- Email is one of the most used services on the Internet.

- Email delivery over the Internet requires the following components:

    1. Mail Submission Agent (MSA)
    2. Mail Transfer Agent (MTA)
    3. Mail Delivery Agent (MDA)
    4. Mail User Agent (MUA)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/822a449fd569c16c875a13ca2487b714.png)

- The figure shows the following five steps that an email needs to go through to reach the recipient’s inbox:

    1. A Mail User Agent (MUA), or simply an email client, has an email message to be sent. The MUA connects to a Mail Submission Agent (MSA) to send its message.
    2. The MSA receives the message, checks for any errors before transferring it to the Mail Transfer Agent (MTA) server, commonly hosted on the same server.
    3. The MTA will send the email message to the MTA of the recipient. The MTA can also function as a Mail Submission Agent (MSA).
    4. A typical setup would have the MTA server also functioning as a Mail Delivery Agent (MDA).
    5. The recipient will collect its email from the MDA using their email client.

- If the above steps sound confusing, consider the following analogy:

    1. You (MUA) want to send postal mail.
    2. The post office employee (MSA) checks the postal mail for any issues before your local post office (MTA) accepts it.
    3. The local post office checks the mail destination and sends it to the post office (MTA) in the correct country.
    4. The post office (MTA) delivers the mail to the recipient mailbox (MDA).
    5. The recipient (MUA) regularly checks the mailbox for new mail. They notice the new mail, and they take it.

- In the same way, we need to follow a protocol to communicate with an HTTP server, and we need to rely on email protocols to talk with an MTA and an MDA. The protocols are:

    - Simple Mail Transfer Protocol (SMTP)
    - Post Office Protocol version 3 (POP3) or Internet Message Access Protocol (IMAP)

**SMTP**:

- Simple Mail Transfer Protocol (SMTP) is used to communicate with an MTA server. 
- Because SMTP uses cleartext, where all commands are sent without encryption, we can use a basic Telnet client to connect to an SMTP server and act as an email client (MUA) sending a message.
- SMTP server listens on port 25 by default. 

- To see basic communication with an SMTP server, we used Telnet to connect to it. Once connected, we issue `helo hostname` and then start typing our email.
```
           
pentester@TryHackMe$ telnet 10.10.160.171 25
Trying 10.10.160.171...
Connected to 10.10.160.171.
Escape character is '^]'.
220 bento.localdomain ESMTP Postfix (Ubuntu)
helo telnet
250 bento.localdomain
mail from: 
250 2.1.0 Ok
rcpt to: 
250 2.1.5 Ok
data
354 End data with .
subject: Sending email with Telnet
Hello Frank,
I am just writing to say hi!             
.
250 2.0.0 Ok: queued as C3E7F45F06
quit
221 2.0.0 Bye
Connection closed by foreign host.
```

After helo, we issue mail from:, rcpt to: to indicate the sender and the recipient. When we send our email message, we issue the command data and type our message. We issue `<CR><LF>.<CR><LF>` (or `Enter . Enter` to put it in simpler terms). The SMTP server now queues the message.

---

## Post Office Protocol 3 (POP3)


- Post Office Protocol version 3 (POP3) is a protocol used to download the email messages from a Mail Delivery Agent (MDA) server.
- The mail client connects to the POP3 server, authenticates, downloads the new email messages before (optionally) deleting them.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/ed910ad418376edc846846fc2a0dd3f6.png)


The example below shows what a POP3 session would look like if conducted via a Telnet client. First, the user connects to the POP3 server at the POP3 default port 110. Authentication is required to access the email messages; the user authenticates by providing his username `USER frank` and password `PASS D2xc9CgD`. Using the command `STAT`, we get the reply `+OK 1 179`; based on RFC 1939, a positive response to `STAT` has the format `+OK nn mm`, where nn is the number of email messages in the inbox, and mm is the size of the inbox in octets (byte). The command `LIST` provided a list of new messages on the server, and `RETR 1` retrieved the first message in the list.

```
           
pentester@TryHackMe$ telnet 10.10.160.171 110
Trying 10.10.160.171...
Connected to 10.10.160.171.
Escape character is '^]'.
+OK 10.10.160.171 Mail Server POP3 Wed, 15 Sep 2021 11:05:34 +0300 
USER frank
+OK frank
PASS D2xc9CgD
+OK 1 messages (179) octets
STAT
+OK 1 179
LIST
+OK 1 messages (179) octets
1 179
.
RETR 1
+OK
From: Mail Server 
To: Frank 
subject: Sending email with Telnet
Hello Frank,
I am just writing to say hi!
.
QUIT
+OK 10.10.160.171 closing connection
Connection closed by foreign host.

```

The example above shows that the commands are sent in cleartext. Using Telnet was enough to authenticate and retrieve an email message. As the username and password are sent in cleartext, any third party watching the network traffic can steal the login credentials.

In general, your mail client (MUA) will connect to the POP3 server (MDA), authenticate, and download the messages. Although the communication using the POP3 protocol will be hidden behind a sleek interface, similar commands will be issued, as shown in the Telnet session above.

Based on the default settings, the mail client deletes the mail message after it downloads it. The default behaviour can be changed from the mail client settings if you wish to download the emails again from another mail client. Accessing the same mail account via multiple clients using POP3 is usually not very convenient as one would lose track of read and unread messages. To keep all mailboxes synchronized, we need to consider other protocols, such as IMAP.

---

## Internet Message Access Protocol (IMAP)


- Internet Message Access Protocol (IMAP) is more sophisticated than POP3. 
- Port 143 by default. 
- IMAP makes it possible to keep your email synchronized across multiple devices (and mail clients).

In other words, if you mark an email message as read when checking your email on your smartphone, the change will be saved on the IMAP server (MDA) and replicated on your laptop when you synchronize your inbox.


Let’s take a look at sample IMAP commands. In the console output below, we use Telnet to connect to the IMAP server’s default port, and then we authenticate using `LOGIN username password`. IMAP requires each command to be preceded by a random string to be able to track the reply. So we added `c1`, then `c2`, and so on. Then we listed our mail folders using `LIST "" "*"`, before checking if we have any new messages in the inbox using `EXAMINE INBOX`.

```
           
pentester@TryHackMe$ telnet 10.10.160.171 143
Trying 10.10.160.171...
Connected to 10.10.160.171.
Escape character is '^]'.
* OK [CAPABILITY IMAP4rev1 UIDPLUS CHILDREN NAMESPACE THREAD=ORDEREDSUBJECT THREAD=REFERENCES SORT QUOTA IDLE ACL ACL2=UNION STARTTLS ENABLE UTF8=ACCEPT] Courier-IMAP ready. Copyright 1998-2018 Double Precision, Inc.  See COPYING for distribution information.
c1 LOGIN frank D2xc9CgD
* OK [ALERT] Filesystem notification initialization error -- contact your mail administrator (check for configuration errors with the FAM/Gamin library)
c1 OK LOGIN Ok.
c2 LIST "" "*"
* LIST (\HasNoChildren) "." "INBOX.Trash"
* LIST (\HasNoChildren) "." "INBOX.Drafts"
* LIST (\HasNoChildren) "." "INBOX.Templates"
* LIST (\HasNoChildren) "." "INBOX.Sent"
* LIST (\Unmarked \HasChildren) "." "INBOX"
c2 OK LIST completed
c3 EXAMINE INBOX
* FLAGS (\Draft \Answered \Flagged \Deleted \Seen \Recent)
* OK [PERMANENTFLAGS ()] No permanent flags permitted
* 0 EXISTS
* 0 RECENT
* OK [UIDVALIDITY 631694851] Ok
* OK [MYRIGHTS "acdilrsw"] ACL
c3 OK [READ-ONLY] Ok
c4 LOGOUT
* BYE Courier-IMAP server shutting down
c4 OK LOGOUT completed
Connection closed by foreign host.

```

It is clear that IMAP sends the login credentials in cleartext, as we can see in the command LOGIN frank D2xc9CgD. Anyone watching the network traffic would be able to know Frank’s username and password. 

---

## Summary


| Protocol | TCP Port | Application(s) | Data Security |
| -------- | -------- | -------------- | ------------- |
| FTP      | 21       | File Transfer  | Cleartext     |
| HTTP     | 80       | Worldwide Web  | Cleartext     |
| IMAP     | 143      | Email (MDA)    | Cleartext     |
| POP3     | 110      | Email (MDA)    | Cleartext     |
| SMTP     | 25       | Email (MTA)    | Cleartext     |
| Telnet   | 23       | Remote Access  | Cleartext     |