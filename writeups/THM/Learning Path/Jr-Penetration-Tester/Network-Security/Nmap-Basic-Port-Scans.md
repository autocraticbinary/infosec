# Nmap Basic Port Scans

---

## TCP and UDP Ports


- In the same sense that an IP address specifies a host on a network among many others, a TCP port or UDP port is used to identify a network service running on that host.
- A server provides the network service, and it adheres to a specific network protocol.
- A port is usually linked to a service using that specific port number.

At the risk of oversimplification, we can classify ports in two states:

   - Open port indicates that there is some service listening on that port.
   - Closed port indicates that there is no service listening on that port.

Nmap considers the following six states:

   - Open: indicates that a service is listening on the specified port.
   - Closed: indicates that no service is listening on the specified port, although the port is accessible. By accessible, we mean that it is reachable and is not blocked by a firewall or other security appliances/programs.
   - Filtered: means that Nmap cannot determine if the port is open or closed because the port is not accessible. This state is usually due to a firewall preventing Nmap from reaching that port. Nmap’s packets may be blocked from reaching the port; alternatively, the responses are blocked from reaching Nmap’s host.
   - Unfiltered: means that Nmap cannot determine if the port is open or closed, although the port is accessible. This state is encountered when using an ACK scan `-sA`.
   - Open|Filtered: This means that Nmap cannot determine whether the port is open or filtered.
   - Closed|Filtered: This means that Nmap cannot decide whether a port is closed or filtered.

---

## TCP Flags


- Nmap supports different types of TCP port scans. 
- To understand the difference between these port scans, we need to review the TCP header.
- The TCP header is the first 24 bytes of a TCP segment. 

The following figure shows the TCP header as defined in RFC 793. This figure looks sophisticated at first; however, it is pretty simple to understand. In the first row, we have the source TCP port number and the destination port number. We can see that the port number is allocated 16 bits (2 bytes). In the second and third rows, we have the sequence number and the acknowledgement number. Each row has 32 bits (4 bytes) allocated, with six rows total, making up 24 bytes.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/79ca8e4acbd573a27cee413cde927769.png)

Setting a flag bit means setting its value to 1. From left to right, the TCP header flags are:

   - URG: Urgent flag indicates that the urgent pointer filed is significant. The urgent pointer indicates that the incoming data is urgent, and that a TCP segment with the URG flag set is processed immediately without consideration of having to wait on previously sent TCP segments.
   - ACK: Acknowledgement flag indicates that the acknowledgement number is significant. It is used to acknowledge the receipt of a TCP segment.
   - PSH: Push flag asking TCP to pass the data to the application promptly.
   - RST: Reset flag is used to reset the connection. Another device, such as a firewall, might send it to tear a TCP connection. This flag is also used when data is sent to a host and there is no service on the receiving end to answer.
   - SYN: Synchronize flag is used to initiate a TCP 3-way handshake and synchronize sequence numbers with the other host. The sequence number should be set randomly during TCP connection establishment.
   - FIN: The sender has no more data to send.

---

## TCP Connect Scan


- TCP connect scan works by completing the TCP 3-way handshake.
- In standard TCP connection establishment, the client sends a TCP packet with SYN flag set, and the server responds with SYN/ACK if the port is open; finally, the client completes the 3-way handshake by sending an ACK.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/8390020a13d6f22f49233833f6265de6.png)

- We are interested in learning whether the TCP port is open, not establishing a TCP connection. Hence the connection is torn as soon as its state is confirmed by sending a RST/ACK. You can choose to run TCP connect scan using -sT. 

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/514972cd54b3f58c83f951978ea9183e.png)


- It is important to note that if you are not a privileged user (root or sudoer), a TCP connect scan is the only possible option to discover open TCP ports.
- A closed TCP port responds to a SYN packet with RST/ACK to indicate that it is not open.


We notice that port 143 is open, so it replied with a SYN/ACK, and Nmap completed the 3-way handshake by sending an ACK. The figure below shows all the packets exchanged between our Nmap host and the target system’s port 143. The first three packets are the TCP 3-way handshake being completed. Then, the fourth packet tears it down with an RST/ACK packet.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/19ebc8172c930867c50e214b630ef4ec.png)


`nmap -sT MACHINE_IP`

Note that we can use `-F` to enable fast mode and decrease the number of scanned ports from 1000 to 100 most common ports.

It is worth mentioning that the `-r` option can also be added to scan the ports in consecutive order instead of random order. This option is useful when testing whether ports open in a consistent manner, for instance, when a target boots up.

---

## TCP SYN Scan


- Unprivileged users are limited to connect scan.
- However, the default scan mode is SYN scan, and it requires a privileged (root or sudoer) user to run it.

- SYN scan does not need to complete the TCP 3-way handshake; instead, it tears down the connection once it receives a response from the server.
- Because we didn’t establish a TCP connection, this decreases the chances of the scan being logged.
- We can select this scan type by using the `-s`S option.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/48e631fd3deba4a2b759ca48405fcc08.png)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/fe642b2fafb70cbaa2531d2c41d6cddb.png)

- TCP SYN scan is the default scan mode when running Nmap as a privileged user, running as root or using sudo, and it is a very reliable choice.

---

## UDP Scan


- UDP is a connectionless protocol, and hence it does not require any handshake for connection establishment. 
- We cannot guarantee that a service listening on a UDP port would respond to our packets. However, if a UDP packet is sent to a closed port, an ICMP port unreachable error (type 3, code 3) is returned.
- You can select UDP scan using the `-sU` option; moreover, you can combine it with another TCP scan.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/085088cd1b2b122312b1ee952c4aa0f7.png)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/8b8b32517699b96777641a97dbf9d880.png)

---

## Fine-Tuning Scope and Performance


- port list: `-p22,80,443` will scan ports 22, 80 and 443.
- port range: `-p1-1023` will scan all ports between 1 and 1023 inclusive

- Request the scan of all ports by using `-p-`, which will scan all 65535 ports.
- To scan the most common 100 ports, add `-F`.
- Using `--top-ports 10` will check the ten most common ports.

- Control the scan timing using -T<0-5>.
- `-T0` is the slowest (paranoid), while `-T5` is the fastest.

    - paranoid (0)
    - sneaky (1)
    - polite (2)
    - normal (3)
    - aggressive (4)
    - insane (5)

To avoid IDS alerts, you might consider `-T0` or `-T1`. For instance, `-T0` scans one port at a time and waits 5 minutes between sending each probe, so you can guess how long scanning one target would take to finish. If you don’t specify any timing, Nmap uses normal `-T3`. Note that `-T5` is the most aggressive in terms of speed; however, this can affect the accuracy of the scan results due to the increased likelihood of packet loss. Note that `-T4` is often used during CTFs and when learning to scan on practice targets, whereas `-T1` is often used during real engagements where stealth is more important.

Alternatively, you can choose to control the packet rate using `--min-rate <number>` and `--max-rate <number>`. For example, `--max-rate 10` or `--max-rate=10` ensures that your scanner is not sending more than ten packets per second. 

Moreover, you can control probing parallelization using `--min-parallelism <numprobes>` and `--max-parallelism <numprobes>`. Nmap probes the targets to discover which hosts are live and which ports are open; probing parallelization specifies the number of such probes that can be run in parallel. For instance, `--min-parallelism=512` pushes Nmap to maintain at least 512 probes in parallel; these 512 probes are related to host discovery and open ports.