
---

- Add an IP to your hosts file manually. This can be accomplished by editing the `/etc/hosts` file on Linux/MacOS, or `C:\Windows\System32\drivers\etc\hosts` on Windows, to include the IP address, followed by a tab, then the domain name. **Note:** this _must_ be done as root/Administrator.
- Get a reverse shell from the target. You can either do this manually, or by typing `shell` into the pseudoshell and following the instructions given.
- Stabilise the reverse shell. (https://book.hacktricks.xyz/generic-methodologies-and-resources/shells/full-ttys)
- Pivoting is the art of using access obtained over one machine to exploit another machine deeper in the network. It is one of the most essential aspects of network penetration testing.

Put simply, by using one of the techniques described in the following tasks (or others!), it becomes possible for an attacker to gain initial access to a remote network, and use it to access other machines in the network that would not otherwise be accessible:

![[Pasted image 20240814184140.png]]

In this diagram, there are four machines on the target network: one public facing server, with three machines which are not exposed to the internet. By accessing the public server, we can then pivot to attack the remaining three targets.

- The methods we use to pivot tend to vary between the different target operating systems.
- There are two main methods encompassed in this area (pivoting) of pentesting:
	- **Tunnelling/Proxying:** Creating a proxy type connection through a compromised machine in order to route all desired traffic into the targeted network. This could potentially also be _tunnelled_ inside another protocol (e.g. SSH tunnelling), which can be useful for evading a basic **I**ntrusion **D**etection **S**ystem (IDS) or firewall  
    
	- **Port Forwarding:** Creating a connection between a local port and a single port on a target, via a compromised host

- A proxy is good if we want to redirect lots of different kinds of traffic into our target network -- for example, with an nmap scan, or to access multiple ports on multiple different machines.
- Port Forwarding tends to be faster and more reliable, but only allows us to access a single port (or a small range) on a target device.
- Which style of pivoting is more suitable will depend entirely on the layout of the network, so we'll have to start with further enumeration before we decide how to proceed.


#### Task 9

- There are five possible ways to enumerate a network through a compromised host:

	1. Using material found on the machine. The hosts file or ARP cache, for example  
	2. Using pre-installed tools  
	3. Using statically compiled tools
	4. Using scripting techniques
	5. Using local tools through a proxy

	These are written in the order of preference. Using local tools through a proxy is incredibly slow, so should only be used as a last resort. Ideally we want to take advantage of pre-installed tools on the system (Linux systems sometimes have Nmap installed by default, for example). This is an example of Living off the Land (LotL) -- a good way to minimise risk. Failing that, it's very easy to transfer a static binary, or put together a simple ping-sweep tool in Bash

-  `arp -a` can be used to Windows or Linux to check the ARP cache of the machine -- this will show you any IP addresses of hosts that the target has interacted with recently.
- Equally, static mappings may be found in `/etc/hosts` on Linux, or `C:\Windows\System32\drivers\etc\hosts` on Windows.
- `/etc/resolv.conf` on Linux may also identify any local DNS servers, which may be misconfigured to allow something like a DNS zone transfer attack (which is outwith the scope of this content, but worth looking into).
- On Windows the easiest way to check the DNS servers for an interface is with `ipconfig /all`. Linux has an equivalent command as an alternative to reading the resolv.conf file: `nmcli dev show`.
- statically compiled copies of different tools for different operating systems can be found in various places on the internet. A good (if dated) resource for these can be found [here](https://github.com/andrew-d/static-binaries).

Be aware that many repositories of static tools are very outdated. Tools from these repositories will likely still do the job; however, you may find that they require different syntax, or don't work in quite the way that you've come to expect.

_The difference between a "static" binary and a "dynamic" binary is in the compilation. Most programs use a variety of external libraries (_`.so` _files on Linux, or_ `.dll` _files on Windows) -- these are referred to as "dynamic" programs. Static programs are compiled with these libraries built into the finished executable file._

- Finally, the dreaded scanning through a proxy. This should be an absolute last resort, as scanning through something like proxychains is _very_ slow, and often limited (you cannot scan UDP ports through a TCP proxy, for example). The one exception to this rule is when using the Nmap Scripting Engine (NSE), as the scripts library does not come with the statically compiled version of the tool. As such, you can use a static copy of Nmap to sweep the network and find hosts with open ports, then use your local copy of Nmap through a proxy _specifically against the found ports_.

- the following Bash one-liner would perform a full ping sweep of the 192.168.1.x network: `for i in {1..255}; do (ping -c 1 192.168.1.${i} | grep "bytes from" &); done`

The above command generates a full list of numbers from 1 to 255 and loops through it. For each number, it sends one ICMP ping packet to 192.168.1.x as a backgrounded job (meaning that each ping runs in parallel for speed), where i is the current number. Each response is searched for "bytes from" to see if the ping was successful. Only successful responses are shown.

The above command generates a full list of numbers from 1 to 255 and loops through it. For each number, it sends one ICMP ping packet to 192.168.1.x as a backgrounded job (meaning that each ping runs in parallel for speed), where i is the current number. Each response is searched for "bytes from" to see if the ping was successful. Only successful responses are shown.

It's worth noting as well that you may encounter hosts which have firewalls blocking ICMP pings (Windows boxes frequently do this, for example). This is likely to be less of a problem when pivoting, however, as these firewalls (by default) often only apply to external traffic, meaning that anything sent through a compromised host on the network should be safe. It's worth keeping in mind, however.

If you suspect that a host is active but is blocking ICMP ping requests, you could also check some common ports using a tool like netcat.

- Port scanning in bash can be done (ideally) entirely natively: `for i in {1..65535}; do (echo > /dev/tcp/192.168.1.1/$i) >/dev/null 2>&1 && echo $i is open; done`



#### Task 10

- Proxychains is a command line tool which is activated by prepending the command `proxychains` to other commands. For example, to proxy netcat  through a proxy, you could use the command:  `proxychains nc 172.16.0.10 23`

Notice that a proxy port was not specified in the above command. This is because proxychains reads its options from a config file. The master config file is located at `/etc/proxychains.conf`. This is where proxychains will look by default; however, it's actually the last location where proxychains will look. The locations (in order) are:

1. The current directory (i.e. `./proxychains.conf`)
2. `~/.proxychains/proxychains.conf`
3. `/etc/proxychains.conf`

This makes it extremely easy to configure proxychains for a specific assignment, without altering the master file. Simply execute: `cp /etc/proxychains.conf .`, then make any changes to the config file in a copy stored in your current directory. If you're likely to move directories a lot then you could instead place it in a `.proxychains` directory under your home directory, achieving the same results. If you happen to lose or destroy the original master copy of the proxychains config, a replacement can be downloaded from [here](https://raw.githubusercontent.com/haad/proxychains/master/src/proxychains.conf).

Speaking of the `proxychains.conf` file, there is only one section of particular use to us at this moment of time: right at the bottom of the file are the servers used by the proxy. You can set more than one server here to chain proxies together, however, for the time being we will stick to one proxy:

![[Pasted image 20240814205003.png]]

It is here that we can choose which port(s) to forward the connection through. By default there is one proxy set to localhost port 9050 -- this is the default port for a Tor entrypoint, should you choose to run one on your attacking machine. That said, it is not hugely useful to us. This should be changed to whichever (arbitrary) port is being used for the proxies we'll be setting up in the following tasks.


There is one other line in the Proxychains configuration that is worth paying attention to, specifically related to the Proxy DNS settings:  

![Screenshot showing the proxy_dns line in the Proxychains config](https://assets.tryhackme.com/additional/wreath-network/3af17f6ddafc.png)  

If performing an Nmap scan through proxychains, this option can cause the scan to hang and ultimately crash. Comment out the `proxy_dns` line using a hashtag (`#`) at the start of the line before performing a scan through the proxy!  

![Proxy_DNS line commented out with a hashtag](https://assets.tryhackme.com/additional/wreath-network/557437aec525.png)

Other things to note when scanning through proxychains:

- You can only use TCP scans -- so no UDP or SYN scans. ICMP Echo packets (Ping requests) will also not work through the proxy, so use the  `-Pn`  switch to prevent Nmap from trying it.
- It will be _extremely_ slow. Try to only use Nmap through a proxy when using the NSE (i.e. use a static binary to see where the open ports/hosts are before proxying a local copy of nmap to use the scripts library).