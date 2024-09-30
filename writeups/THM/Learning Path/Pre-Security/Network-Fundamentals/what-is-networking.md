# What is Networking

---

`Date : 24/8/24`

> Network

    - A computer network is a group of interconnected nodes or computing devices that exchange data and resources with each other. A network connection between these devices can be established using cable or wireless media.

> Internet

    - The Internet is one giant network that consists of many, many small networks within itself.
    
    - The first iteration of the Internet was within the ARPANET project in the late 1960s. This project was funded by the United States Defence Department and was the first documented network in action. However, it wasn't until 1989 when the Internet as we know it was invented by Tim Berners-Lee by the creation of the World Wide Web (WWW).

![Internet](https://assets.tryhackme.com/additional/networking-fundamentals/intro-to-networking/what-is-the-internet/internet2.png)

    - As previously stated, the Internet is made up of many small networks all joined together.  These small networks are called private networks, where networks connecting these small networks are called public networks -- or the Internet! So, to recap, a network can be one of two types:

        - A private network
        - A public network

- Device have two means of identifcation
    - IP Address
    - Media Access Control (MAC) Address

> IP Address

    - An IP address (or Internet Protocol) address can be used as a way of identifying a host on a network for a period of time, where that IP address can then be associated with another device without the IP address changing.

![IP address](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de96d9ca744773ea7ef8c00/room-content/a0de0d68641982ddf1a8c5a9f1984c4c.png)

    - An IP address is a set of numbers that are divided into four octets.
    - The value of each octet will summarise to be the IP address of the device on the network.
    - This number is calculated through a technique known as IP addressing & subnetting.

    - IP Addresses follow a set of standards known as protocols.
    - These protocols are the backbone of networking and force many devices to communicate in the same language.
    - However, we should recall that devices can be on both a private and public network. Depending on where they are will determine what type of IP address they have: a public or private IP address.

    - A public address is used to identify the device on the Internet, whereas a private address is used to identify a device amongst other devices.

    | Device Name |	IP Address | IP Address Type |
    | :---------: | :--------: | :-------------: |
    | DESKTOP-KJE57FD | 192.168.1.77 | Private |
    | DESKTOP-KJE57FD | 86.157.52.21 | Public |
    | CMNatic-PC | 192.168.1.74 | Private |
    | CMNatic-PC | 86.157.52.21 | Public |


![](https://assets.tryhackme.com/additional/cmn-aoc2020/day-8/1.png)

    These two devices will be able to use their private IP addresses to communicate with each other. However, any data sent to the Internet from either of these devices will be identified by the same public IP address. Public IP addresses are given by your Internet Service Provider (or ISP) at a monthly fee (your bill!)


    - Two versions of the Internet Protocol addressing scheme
        - IPv4
            - Supports up to 2^32 of IP addresses (4.29 billion)
        - IPv6
            - Supports up to 2^128 of IP addresses (340 trillion-plus)
            - Resolving the issues faced with IPv4
            - More efficient due to new methodologies

> MAC Addresses

    - Devices on a network will all have a physical network interface, which is a microchip board found on the device's motherboard.
    - This network interface is assigned a unique address at the factory it was built at, called a MAC (Media Access Control ) address.
    - The MAC address is a twelve-character hexadecimal number (a base sixteen numbering system used in computing to represent numbers) split into two's and separated by a colon.
    - The first six characters represent the company that made the network interface, and the last six is a unique number.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5de96d9ca744773ea7ef8c00/room-content/394caee97fb1b9f7b5a5f7a7ea0a9f71.png)

    - However, an interesting thing with MAC addresses is that they can be faked or "spoofed" in a process known as spoofing. This spoofing occurs when a networked device pretends to identify as another using its MAC address. When this occurs, it can often break poorly implemented security designs that assume that devices talking on a network are trustworthy. Take the following scenario: A firewall is configured to allow any communication going to and from the MAC address of the administrator. If a device were to pretend or "spoof" this MAC address, the firewall would now think that it is receiving communication from the administrator when it isn't.

---

### Ping (ICMP)

> Ping

    - Ping is one of the most fundamental network tools.
    - Ping uses ICMP (Internet Control Message Protocol) packets to determine the performance of a connection between devices, for example, if the connection exists or is reliable.
    - The time taken for ICMP packets travelling between devices is measured by ping, such as in the screenshot below. This measuring is done using ICMP's echo packet and then ICMP's echo reply from the target device.

![ping](https://assets.tryhackme.com/additional/networking-fundamentals/intro-to-networking/ping/ping1.png)

    - Pings can be performed against devices on a network, such as your home network or resources like websites.
