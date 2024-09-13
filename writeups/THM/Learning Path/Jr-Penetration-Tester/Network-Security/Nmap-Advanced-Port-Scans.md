# Nmap Advanced Port Scans

---

## Introduction


![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/23540a5fcd27454892a73ac051d29664.png)

---

## TCP Null Scan, FIN Scan, and Xmas Scan


### Null Scan

- The null scan does not set any flag; all six flag bits are set to zero. 
- You can choose this scan using the `-sN` option.
- A TCP packet with no flags set will not trigger any response when it reaches an open port, as shown in the figure below.
- Therefore, from Nmap’s perspective, a lack of reply in a null scan indicates that either the port is open or a firewall is blocking the packet. 

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/04b178a9cf7048c21256988b8b2343e3.png)

- However, we expect the target server to respond with an RST packet if the port is closed. Consequently, we can use the lack of RST response to figure out the ports that are not closed: open or filtered.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/224e01a913a1ce7b0fb2b9290ff5e1c8.png)


`sudo nmap -sN MACHINE_IP`


### FIN Scan

- The FIN scan sends a TCP packet with the FIN flag set.
- You can choose this scan type using the -sF option.
- Similarly, no response will be sent if the TCP port is open. Again, Nmap cannot be sure if the port is open or if a firewall is blocking the traffic related to this TCP port.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/78eb3d6ba158542f2b3223184b032e64.png)

- However, the target system should respond with an RST if the port is closed. Consequently, we will be able to know which ports are closed and use this knowledge to infer the ports that are open or filtered. It's worth noting some firewalls will 'silently' drop the traffic without sending an RST.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/74dc07da7351a5a7f258948ec59efccc.png)


`sudo nmap -sF MACHINE_IP`


### Xmas Scan

- An Xmas scan sets the FIN, PSH, and URG flags simultaneously. 
- You can select Xmas scan with the option `-sX`.
- Like the Null scan and FIN scan, if an RST packet is received, it means that the port is closed. Otherwise, it will be reported as open|filtered.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/7d28b756aed3b6eb72faf98d6974776c.png)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/4304eacbc3db1af21657f285bc16ebce.png)


`sudo nmap -sX MACHINE_IP`


Note:
- One scenario where these three scan types can be efficient is when scanning a target behind a stateless (non-stateful) firewall.
- A stateless firewall will check if the incoming packet has the SYN flag set to detect a connection attempt.
- Using a flag combination that does not match the SYN packet makes it possible to deceive the firewall and reach the system behind it. 
- However, a stateful firewall will practically block all such crafted packets and render this kind of scan useless.

---

## TCP Maimon Scan


- In this scan, the FIN and ACK bits are set. 
- The target should send an RST packet as a response. 
- However, certain BSD-derived systems drop the packet if it is an open port exposing the open ports.
- This scan won’t work on most targets encountered in modern networks.
- To select this scan type, use the `-sM` option. 

- Most target systems respond with an RST packet regardless of whether the TCP port is open.
- In such a case, we won’t be able to discover the open ports.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/8ca5e5e0f6e0a1843cebe11b5b0785b3.png)

`sudo nmap -sM IP`

---

## TCP ACK, Window, and Custom Scan


### TCP ACK Scan

- As the name implies, an ACK scan will send a TCP packet with the ACK flag set.
- Use the `-sA` option to choose this scan. 
- The target would respond to the ACK with RST regardless of the state of the port.

This behaviour happens because a TCP packet with the ACK flag set should be sent only in response to a received TCP packet to acknowledge the receipt of some data, unlike our case. Hence, this scan won’t tell us whether the target port is open in a simple setup.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/a991831cedbb2761dde1fe66012a7311.png)

`sudo nmap -sA MACHINE_IP`

- Launching a TCP ACK scan against a Linux system with no firewall will not provide much information. 

- This kind of scan would be helpful if there is a firewall in front of the target.
- Consequently, based on which ACK packets resulted in responses, you will learn which ports were not blocked by the firewall.
- In other words, this type of scan is more suitable to discover firewall rule sets and configuration.


### Window Scan

- The TCP window scan is almost the same as the ACK scan; however, it examines the TCP Window field of the RST packets returned.
- On specific systems, this can reveal that the port is open.
- You can select this scan type with the option `-sW`.

As shown in the figure below, we expect to get an RST packet in reply to our “uninvited” ACK packets, regardless of whether the port is open or closed.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5118dcb424d429376f09bf2f85db5bce.png)

- Launching a TCP window scan against a Linux system with no firewall will not provide much information. 


### Custom Scan

- If you want to experiment with a new TCP flag combination beyond the built-in TCP scan types, you can do so using `--scanflags`
- For instance, if you want to set SYN, RST, and FIN simultaneously, you can do so using `--scanflags RSTSYNFIN`.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/d76c5020f14ac0d66e7ff3812bb0bec3.png)


**Note**:

- It is essential to note that the ACK scan and the window scan were very efficient at helping us map out the firewall rules. 
- However, it is vital to remember that just because a firewall is not blocking a specific port, it does not necessarily mean that a service is listening on that port. 
- For example, there is a possibility that the firewall rules need to be updated to reflect recent service changes. Hence, ACK and window scans are exposing the firewall rules, not the services.

---

## Spoofing and Decoys


Spoofing the source IP address can be a great approach to scanning stealthily.

In some network setups, you will be able to scan a target system using a spoofed IP address and even a spoofed MAC address. Such a scan is only beneficial in a situation where you can guarantee to capture the response. If you try to scan a target from some random network using a spoofed IP address, chances are you won’t have any response routed to you, and the scan results could be unreliable.

The following figure shows the attacker launching the command `nmap -S SPOOFED_IP TARGET_IP`. Consequently, Nmap will craft all the packets using the provided source IP address `SPOOFED_IP`. The target machine will respond to the incoming packets sending the replies to the destination IP address `SPOOFED_IP`. For this scan to work and give accurate results, the attacker needs to monitor the network traffic to analyze the replies. 

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/45b982d501fd26deb2b381059b16f80c.png)

In brief, scanning with a spoofed IP address is three steps:

   1. Attacker sends a packet with a spoofed source IP address to the target machine.
   2. Target machine replies to the spoofed IP address as the destination.
   3. Attacker captures the replies to figure out open ports.


- In general, you expect to specify the network interface using `-e` and to explicitly disable ping scan `-Pn`.

- Therefore, instead of `nmap -S SPOOFED_IP TARGET_IP`, you will need to issue `nmap -e NET_INTERFACE -Pn -S SPOOFED_IP TARGET_IP` to tell Nmap explicitly which network interface to use and not to expect to receive a ping reply.
- It is worth repeating that this scan will be useless if the attacker system cannot monitor the network for responses. 

When you are on the same subnet as the target machine, you would be able to spoof your MAC address as well. You can specify the source MAC address using `--spoof-mac SPOOFED_MAC`. This address spoofing is only possible if the attacker and the target machine are on the same Ethernet (802.3) network or same WiFi (802.11).

Spoofing only works in a minimal number of cases where certain conditions are met. Therefore, the attacker might resort to using **decoys** to make it more challenging to be pinpointed. The concept is simple, make the scan appear to be coming from many IP addresses so that the attacker’s IP address would be lost among them. As we see in the figure below, the scan of the target machine will appear to be coming from 3 different sources, and consequently, the replies will go the decoys as well.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/754fc455556a424ca83f512665beaf7d.png)

- You can launch a decoy scan by specifying a specific or random IP address after `-D`.

- For example, `nmap -D 10.10.0.1,10.10.0.2,ME TARGET_IP` will make the scan of `TARGET_IP` appear as coming from the IP addresses `10.10.0.1`, `10.10.0.2`, and then `ME` to indicate that your IP address should appear in the third order.
- Another example command would be `nmap -D 10.10.0.1,10.10.0.2,RND,RND,ME TARGET_IP`, where the third and fourth source IP addresses are assigned randomly, while the fifth source is going to be the attacker’s IP address.

---

## Fragmented Packets


### Firewall

- A firewall is a piece of software or hardware that permits packets to pass through or blocks them. 
- It functions based on firewall rules, summarized as blocking all traffic with exceptions or allowing all traffic with exceptions.

- A traditional firewall inspects, at least, the IP header and the transport layer header.
- A more sophisticated firewall would also try to examine the data carried by the transport layer.


### IDS

- An intrusion detection system (IDS) inspects network packets for select behavioural patterns or specific content signatures.
- It raises an alert whenever a malicious rule is met.
- In addition to the IP header and transport layer header, an IDS would inspect the data contents in the transport layer and check if it matches any malicious patterns.


How can you make it less likely for a traditional firewall/IDS to detect your Nmap activity? It is not easy to answer this; however, depending on the type of firewall/IDS, you might benefit from dividing the packet into smaller packet


### Fragmented Packets

- Nmap provides the option `-f` to fragment packets. 
- Once chosen, the IP data will be divided into 8 bytes or less.
- Adding another `-f` (`-f -f` or `-ff`) will split the data into 16 byte-fragments instead of 8. 
- You can change the default value by using the `--mtu`; however, you should always choose a multiple of 8.


To properly understand fragmentation, we need to look at the IP header in the figure below.
In particular, notice the source address taking 32 bits (4 bytes) on the fourth row, while the destination address is taking another 4 bytes on the fifth row. The data that we will fragment across multiple packets is highlighted in red. To aid in the reassembly on the recipient side, IP uses the identification (ID) and fragment offset, shown on the second row of the figure below.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5e55834e2638ba7ec9e84a0900b68ccb.png)


- Note that if you added -ff (or -f -f), the fragmentation of the data will be multiples of 16.
- On the other hand, if you prefer to increase the size of your packets to make them look innocuous, you can use the option `--data-length NUM`, where num specifies the number of bytes you want to append to your packets.

---

## Idle/Zombie Scan


- The idle scan, or zombie scan, requires an idle system connected to the network that you can communicate with. 
- Practically, Nmap will make each probe appear as if coming from the idle (zombie) host, then it will check for indicators whether the idle (zombie) host received any response to the spoofed probe. 
- This is accomplished by checking the IP identification (IP ID) value in the IP header.
- You can run an idle scan using `nmap -sI ZOMBIE_IP TARGET_IP`, where `ZOMBIE_IP` is the IP address of the idle host (zombie). 

The idle (zombie) scan requires the following three steps to discover whether a port is open:

   1. Trigger the idle host to respond so that you can record the current IP ID on the idle host.
   2. Send a SYN packet to a TCP port on the target. The packet should be spoofed to appear as if it was coming from the idle host (zombie) IP address.
   3. Trigger the idle machine again to respond so that you can compare the new IP ID with the one received earlier.

Explanation:

Let’s explain with figures. In the figure below, we have the attacker system probing an idle machine, a multi-function printer. By sending a SYN/ACK, it responds with an RST packet containing its newly incremented IP ID.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/a93e181f0effe000554a8b307448bbb2.png)

The attacker will send a SYN packet to the TCP port they want to check on the target machine in the next step. However, this packet will use the idle host (zombie) IP address as the source. Three scenarios would arise. In the first scenario, shown in the figure below, the TCP port is closed; therefore, the target machine responds to the idle host with an RST packet. The idle host does not respond; hence its IP ID is not incremented.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/8e28bf940936ddbc2367b193ea3550b8.png)

In the second scenario, as shown below, the TCP port is open, so the target machine responds with a SYN/ACK to the idle host (zombie). The idle host responds to this unexpected packet with an RST packet, thus incrementing its IP ID.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/2b0de492e2154a30760852e07cebae0e.png)

In the third scenario, the target machine does not respond at all due to firewall rules. This lack of response will lead to the same result as with the closed port; the idle host won’t increase the IP ID.

For the final step, the attacker sends another SYN/ACK to the idle host. The idle host responds with an RST packet, incrementing the IP ID by one again. The attacker needs to compare the IP ID of the RST packet received in the first step with the IP ID of the RST packet received in this third step. If the difference is 1, it means the port on the target machine was closed or filtered. However, if the difference is 2, it means that the port on the target was open.

It is worth repeating that this scan is called an idle scan because choosing an idle host is indispensable for the accuracy of the scan. If the “idle host” is busy, all the returned IP IDs would be useless.

---

## Getting More Details


- You might consider adding `--reason` if you want Nmap to provide more details regarding its reasoning and conclusions.
`sudo nmap -sS --reason 10.10.252.27`

- For more detailed output, you can consider using `-v` for verbose output or `-vv` for even more verbosity.
`sudo nmap -sS -vv 10.10.252.27`

- you can use `-d` for debugging details or `-dd` for even more details. You can guarantee that using `-d` will create an output that extends beyond a single screen.

---

## Summary


| Port Scan Type                 | Example Command                                       |
| ------------------------------ | ----------------------------------------------------- |
| TCP Null Scan                  | `sudo nmap -sN MACHINE_IP`                            |
| TCP FIN Scan                   | `sudo nmap -sF MACHINE_IP`                            |
| TCP Xmas Scan                  | `sudo nmap -sX MACHINE_IP`                            |
| TCP Maimon Scan                | `sudo nmap -sM MACHINE_IP`                            |
| TCP ACK Scan                   | `sudo nmap -sA MACHINE_IP`                            |
| TCP Window Scan                | `sudo nmap -sW MACHINE_IP`                            |
| Custom TCP Scan                | `sudo nmap --scanflags URGACKPSHRSTSYNFIN MACHINE_IP` |
| Spoofed Source IP              | `sudo nmap -S SPOOFED_IP MACHINE_IP`                  |
| Spoofed MAC Address            | `--spoof-mac SPOOFED_MAC`                             |
| Decoy Scan                     | `nmap -D DECOY_IP,ME MACHINE_IP`                      |
| Idle (Zombie) Scan             | `sudo nmap -sI ZOMBIE_IP MACHINE_IP`                  |
| Fragment IP data into 8 bytes  | `-f`                                                  |
| Fragment IP data into 16 bytes | `-ff`                                                 |


| Option                   | Purpose                                  |
| ------------------------ | ---------------------------------------- |
| `--source-port PORT_NUM` | specify source port number               |
| `--data-length NUM`      | append random data to reach given length |

These scan types rely on setting TCP flags in unexpected ways to prompt ports for a reply. Null, FIN, and Xmas scan provoke a response from closed ports, while Maimon, ACK, and Window scans provoke a response from open and closed ports.


| Option     | Purpose                               |
| ---------- | ------------------------------------- |
| `--reason` | explains how Nmap made its conclusion |
| `-v`       | verbose                               |
| `-vv`      | very verbose                          |
| `-d`       | debugging                             |
| `-dd`      | more details for debugging            |