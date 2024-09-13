# Active Reconnaissance

- Active reconnaissance begins with direct connections made to the target machine.
- Any such connection might leave information in the logs showing the client IP address, time of the connection, and duration of the connection, among other things. 

---

## Web Browser


On the transport level, the browser connects to:

   - TCP port 80 by default when the website is accessed over HTTP
   - TCP port 443 by default when the website is accessed over HTTPS

Add-Ons :
   
   - [FoxyProxy](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard)
   - [User-Agent Switcher and Manager](https://addons.mozilla.org/en-US/firefox/addon/user-agent-string-switcher)
   - [Wappalyzer](https://addons.mozilla.org/en-US/firefox/addon/wappalyzer)

---

## Ping


- The primary purpose of ping is to check whether you can reach the remote system and that the remote system can reach you back.
- Also used to check network connectivity.

The ping is a command that sends an ICMP Echo packet to a remote system. If the remote system is online, and the ping packet was correctly routed and not blocked by any firewall, the remote system should send back an ICMP Echo Reply. Similarly, the ping reply should reach the first system if appropriately routed and not blocked by any firewall.

`ping MACHINE_IP`

`ping -c 4 MACHINE_IP`


- Technically speaking, ping falls under the protocol ICMP (Internet Control Message Protocol).
- ICMP supports many types of queries, but, in particular, we are interested in ping (ICMP echo/type 8) and ping reply (ICMP echo reply/type 0).


Generally speaking, when we don’t get a ping reply back, there are a few explanations that would explain why we didn’t get a ping reply, for example:

   - The destination computer is not responsive; possibly still booting up or turned off, or the OS has crashed.
   - It is unplugged from the network, or there is a faulty network device across the path.
   - A firewall is configured to block such packets. The firewall might be a piece of software running on the system itself or a separate network appliance. Note that MS Windows firewall blocks ping by default.
   - Your system is unplugged from the network.

---

## Traceroute


- The traceroute command traces the route taken by the packets from your system to another host.
- The purpose of a traceroute is to find the IP addresses of the routers or hops that a packet traverses as it goes from your system to a target host.
- This command also reveals the number of routers between the two systems.

- Note that the route taken by the packets might change as many routers use dynamic routing protocols that adapt to network changes.

Linux:
`traceroute MACHINE_IP`

Windows:
`tracert MACHINE_IP`

**How It Works**:

There is no direct way to discover the path from your system to a target system. We rely on ICMP to “trick” the routers into revealing their IP addresses. We can accomplish this by using a small Time To Live (TTL) in the IP header field. Although the T in TTL stands for time, TTL indicates the maximum number of routers/hops that a packet can pass through before being dropped; TTL is not a maximum number of time units. When a router receives a packet, it decrements the TTL by one before passing it to the next router.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/e82c42dcfae78ac592a8d7843465d2d6.png)

However, if the TTL reaches 0, it will be dropped, and an ICMP Time-to-Live exceeded would be sent to the original sender.

In the following figure, the system set TTL to 1 before sending it to the router. The first router on the path decrements the TTL by 1, resulting in a TTL of 0. Consequently, this router will discard the packet and send an ICMP time exceeded in-transit error message. Note that some routers are configured not to send such ICMP messages when discarding a packet.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/948388c823b156813fa30225c2fa3f05.png)


On Linux, traceroute will start by sending UDP datagrams within IP packets of TTL being 1. Thus, it causes the first router to encounter a TTL=0 and send an ICMP Time-to-Live exceeded back. Hence, a TTL of 1 will reveal the IP address of the first router to you. Then it will send another packet with TTL=2; this packet will be dropped at the second router. And so on.

- Depending on the network topology, we might get replies from up to 3 different routers, depending on the route taken by the packet.
- The two stars in the output `3 * 100.66.16.176 (100.66.16.176) 8.006 ms *` indicate that our system didn’t receive two expected ICMP time exceeded in-transit messages.

To summarize, we can notice the following:

   - The number of hops/routers between your system and the target system depends on the time you are running traceroute. There is no guarantee that your packets will always follow the same route, even if you are on the same network or you repeat the traceroute command within a short time.
   - Some routers return a public IP address. You might examine a few of these routers based on the scope of the intended penetration testing.
   - Some routers don’t return a reply.

---

## Telnet


- The command telnet uses the TELNET protocol for remote administration.
- The default port used by telnet is 23.
- From a security perspective, telnet sends all the data, including usernames and passwords, in cleartext.
- Sending in cleartext makes it easy for anyone, who has access to the communication channel, to steal the login credentials.
- The secure alternative is SSH (Secure SHell) protocol.

- Knowing that telnet client relies on the TCP protocol, you can use Telnet to connect to any service and grab its banner.

- Using `telnet IP PORT`, you can connect to any service running on TCP and even exchange a few messages unless it uses encryption.

```
pentester@TryHackMe$ telnet 10.10.185.5 80
Trying 10.10.185.5...
Connected to 10.10.185.5.
Escape character is '^]'.
GET / HTTP/1.1
host: telnet

HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Tue, 17 Aug 2021 11:13:25 GMT
Content-Type: text/html
Content-Length: 867
Last-Modified: Tue, 17 Aug 2021 11:12:16 GMT
Connection: keep-alive
ETag: "611b9990-363"
Accept-Ranges: bytes



...

```

- If we connect to a mail server, we need to use proper commands based on the protocol, such as SMTP and POP3.

---

## Netcat


- Netcat supports both TCP and UDP protocols.
- It can function as a client that connects to a listening port; alternatively, it can act as a server that listens on a port of your choice.

`nc MACHINE_IP PORT`

```
           
pentester@TryHackMe$ nc MACHINE_IP 80
GET / HTTP/1.1
host: netcat

HTTP/1.1 200 OK
Server: nginx/1.6.2
Date: Tue, 17 Aug 2021 11:39:49 GMT
Content-Type: text/html
Content-Length: 867
Last-Modified: Tue, 17 Aug 2021 11:12:16 GMT
Connection: keep-alive
ETag: "611b9990-363"
Accept-Ranges: bytes
...

```

- Note that you might need to press SHIFT+ENTER after the GET line.


- To listen (server) 
`nc -vnlp PORT`
- Client
`nc MACHINE_IP PORT_NUMBER`

- port numbers less than 1024 require root privileges to listen on.