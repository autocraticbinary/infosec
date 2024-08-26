# Netorking Structure

---

## Network Types

- Each network is structured differently and can be set up individually. For this reason, so-called types and topologies have been developed that can be used to categorize these networks.

> Common Terminology

| Network Type | Definition |
| :----------: | :--------: |
| Wide Area Network (WAN) |	Internet |
| Local Area Network (LAN) |	Internal Networks (Ex: Home or Office) |
| Wireless Local Area Network (WLAN) |	Internal Networks accessible over Wi-Fi |
| Virtual Private Network (VPN) |	Connects multiple network sites to one LAN |

### WAN

- Commonly refered to as `The Internet`
- When dealing with networking equipment, we'll often have a WAN Address and LAN Address.
- The WAN one is the address that is generally accessed by the Internet.
- A WAN is just a large number of LANs joined together.
- Many large companies or government agencies will have an "Internal WAN" (also called Intranet, Airgap Network, etc.).
- Generally speaking, the primary way we identify if the network is a WAN is to use a WAN Specific routing protocol such as BGP and if the IP Schema in use is not within RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).

### LAN/WLAN

- LANs (Local Area Network) and WLANs (Wireless Local Area Network) will typically assign IP Addresses designated for local use (RFC 1918, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
- There's nothing different between a LAN or WLAN, other than WLAN's introduce the ability to transmit data without cables.

### VPN

- There are three main types Virtual Private Networks (VPN), but all three have the same goal of making the user feel as if they were plugged into a different network.
  
  - Site-To-Site VPN
  - Remote Access VPN
  - SSL VPN

#### Site-To-Site VPN

- Both the client and server are Network Devices, typically either Routers or Firewalls, and share entire network ranges.
- This is most commonly used to join company networks together over the Internet, allowing multiple locations to communicate over the Internet as if they were local.

#### Remote Access VPN

- This involves the client's computer creating a virtual interface that behaves as if it is on a client's network. 
- If the VPN only creates routes for specific networks (ex: 10.10.10.0/24), this is called a Split-Tunnel VPN, meaning the Internet connection is not going out of the VPN.
- However, for a company, split-tunnel VPN's are typically not ideal because if the machine is infected with malware, network-based detection methods will most likely not work as that traffic goes out the Internet.

#### SSL VPN

- This is essentially a VPN that is done within our web browser and is becoming increasingly common as web browsers are becoming capable of doing anything.
- Typically these will stream applications or entire desktop sessions to your web browser. 


> Book Terms

| Network Type | Definition |
| :----------: | :--------: |
| Global Area Network (GAN) |	Global network (the Internet) |
| Metropolitan Area Network (MAN) |	Regional network (multiple LANs) |
| Wireless Personal Area Network (WPAN) |	Personal network (Bluetooth) |

#### GAN

- A worldwide network such as the Internet is known as a Global Area Network (GAN).
- However, the Internet is not the only computer network of this kind. Internationally active companies also maintain isolated networks that span several WANs and connect company computers worldwide.
- GANs use the glass fibers infrastructure of wide-area networks and interconnect them by international undersea cables or satellite transmission.

#### MAN

- Metropolitan Area Network (MAN) is a broadband telecommunications network that connects several LANs in geographical proximity.
- As a rule, these are individual branches of a company connected to a MAN via leased lines.
- High-performance routers and high-performance connections based on glass fibers are used, which enable a significantly higher data throughput than the Internet.
- The transmission speed between two remote nodes is comparable to communication within a LAN.
- Internationally operating network operators provide the infrastructure for MANs. Cities wired as Metropolitan Area Networks can be integrated supra-regionally in Wide Area Networks (WAN) and internationally in Global Area Networks (GAN).

#### PAN/WPAN

- Modern end devices such as smartphones, tablets, laptops, or desktop computers can be connected ad hoc to form a network to enable data exchange. This can be done by cable in the form of a Personal Area Network (PAN).
- The wireless variant Wireless Personal Area Network (WPAN) is based on Bluetooth or Wireless USB technologies.
- A wireless personal area network that is established via Bluetooth is called Piconet.
- PANs and WPANs usually extend only a few meters and are therefore not suitable for connecting devices in separate rooms or even buildings.
- In the context of the Internet of Things (IoT), WPANs are used to communicate control and monitor applications with low data rates. Protocols such as Insteon, Z-Wave, and ZigBee were explicitly designed for smart homes and home automation.

---

# Network Topologies

- A network topology is a typical arrangement and physical or logical connection of devices in a network.
- The transmission medium layout used to connect devices is the physical topology of the network. For conductive or glass fiber media, this refers to the cabling plan, the positions of the nodes, and the connections between the nodes and the cabling. 
- In contrast, the logical topology is how the signals act on the network media or how the data will be transmitted across the network from one device to the devices' physical connection.

- We can divide the entire network topology area into three areas:

1. Connections

| Wired connections |	Wireless connections |
| :---------------: | :------------------: |
| Coaxial cabling |	Wi-Fi |
| Glass fiber cabling |	Cellular |
| Twisted-pair cabling | Satellite |
| and others | and others |

2. Nodes - Network Interface Controller (NICs)

| Repeaters |	Hubs | Bridges | Switches |
| Router/Modem | Gateways |	Firewalls |

- Network nodes are the transmission medium's connection points to transmitters and receivers of electrical, optical, or radio signals in the medium.
- A node may be connected to a computer, but certain types may have only one microcontroller on a node or may have no programmable device at all.

3. Classifications

- We can imagine a topology as a virtual form or structure of a network.
- This form does not necessarily correspond to the actual physical arrangement of the devices in the network. Therefore these topologies can be either physical or logical.

Network topologies are divided into the following eight basic types:

| Point-to-Point | Bus |
| Star | Ring |
| Mesh | Tree |
| Hybrid | Daisy Chain |

### Point-to-Point

![](https://academy.hackthebox.com/storage/modules/34/redesigned/topo_p2p.png)

### Bus

- All hosts are connected via a transmission medium in the bus topology.
- Every host has access to the transmission medium and the signals that are transmitted over it.
- There is no central network component that controls the processes on it.
- The transmission medium for this can be, for example, a coaxial cable.
- Since the medium is shared with all the others, only one host can send, and all the others can only receive and evaluate the data and see whether it is intended for itself.

![](https://academy.hackthebox.com/storage/modules/34/redesigned/topo_bus.png)

### Star

- The star topology is a network component that maintains a connection to all hosts.
- Each host is connected to the central network component via a separate link.
- This is usually a router, a hub, or a switch.
- These handle the forwarding function for the data packets.
- The data traffic on the central network component can be very high since all data and connections go through it.

![](https://academy.hackthebox.com/storage/modules/34/redesigned/topo_star.png)

### Ring


