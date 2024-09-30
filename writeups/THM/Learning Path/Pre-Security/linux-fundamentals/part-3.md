# Linux Fundamentals Part 3

- scp important.txt ubuntu@192.168.1.30:/home/ubuntu/transferred.txt
- scp ubuntu@192.168.1.30:/home/ubuntu/documents.txt notes.txt 

- Processes are the programs that are running on your machine. 
- They are managed by the kernel, where each process will have an ID associated with it, also known as its PID. The PID increments for the order In which the process starts. I.e. the 60th process will have a PID of 60.

- `pas aux`
- `top`
- `kill PID`

- Below are some of the signals that we can send to a process when it is killed:

    - SIGTERM - Kill the process, but allow it to do some cleanup tasks beforehand
    - SIGKILL - Kill the process - doesn't do any cleanup after the fact
    - SIGSTOP - Stop/suspend a process


> How do Processes Start?

Let's start off by talking about namespaces. The Operating System (OS) uses namespaces to ultimately split up the resources available on the computer to (such as CPU, RAM and priority) processes. Think of it as splitting your computer up into slices -- similar to a cake. Processes within that slice will have access to a certain amount of computing power, however, it will be a small portion of what is actually available to every process overall.

Namespaces are great for security as it is a way of isolating processes from another -- only those that are in the same namespace will be able to see each other.

We previously talked about how PID works, and this is where it comes into play. The process with an ID of 0 is a process that is started when the system boots. This process is the system's init on Ubuntu, such as systemd, which is used to provide a way of managing a user's processes and sits in between the operating system and the user.

For example, once a system boots and it initialises, systemd is one of the first processes that are started. Any program or piece of software that we want to start will start as what's known as a child process of systemd. This means that it is controlled by systemd, but will run as its own process (although sharing the resources from systemd) to make it easier for us to identify and the likes.

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/process1.png)


> Getting Processes/Services to Start on Boot

Some applications can be started on the boot of the system that we own. For example, web servers, database servers or file transfer servers. This software is often critical and is often told to start during the boot-up of the system by administrators.

In this example, we're going to be telling the apache web server to be starting apache manually and then telling the system to launch apache2 on boot.

Enter the use of systemctl -- this command allows us to interact with the systemd process/daemon. Continuing on with our example, systemctl is an easy to use command that takes the following formatting: systemctl [option] [service]

For example, to tell apache to start up, we'll use systemctl start apache2. Seems simple enough, right? Same with if we wanted to stop apache, we'd just replace the [option] with stop (instead of start like we provided)

We can do four options with systemctl:

    Start
    Stop
    Enable
    Disable

> An Introduction to Backgrounding and Foregrounding in Linux

Processes can run in two states: In the background and in the foreground. For example, commands that you run in your terminal such as "echo" or things of that sort will run in the foreground of your terminal as it is the only command provided that hasn't been told to run in the background. "Echo" is a great example as the output of echo will return to you in the foreground, but wouldn't in the background - take the screenshot below, for example.

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/bg1.png)

Here we're running echo "Hi THM" , where we expect the output to be returned to us like it is at the start. But after adding the & operator to the command, we're instead just given the ID of the echo process rather than the actual output -- as it is running in the background.

This is great for commands such as copying files because it means that we can run the command in the background and continue on with whatever further commands we wish to execute (without having to wait for the file copy to finish first)

We can do the exact same when executing things like scripts -- rather than relying on the & operator, we can use Ctrl + Z on our keyboard to background a process. It is also an effective way of "pausing" the execution of a script or command like in the example below:

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/bg2.png)

This script will keep on repeating "This will keep on looping until I stop!" until I stop or suspend the process. By using Ctrl + Z (as indicated by T^Z). Now our terminal is no longer filled up with messages -- until we foreground it, which we will discuss below.


> Foregrounding a process

Now that we have a process running in the background, for example, our script "background.sh" which can be confirmed by using the ps aux command, we can back-pedal and bring this process back to the foreground to interact with.

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/bg3.png)

With our process backgrounded using either Ctrl + Z or the & operator, we can use fg to bring this back to focus like below, where we can see the fg command is being used to bring the background process back into use on the terminal, where the output of the script is now returned to us.

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/bg4.png)

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/bg5.png)


> cron

Crontabs require 6 specific values:

| Value	| Description |
|-------|-------------|
| MIN	  | What minute to execute at |
| HOUR	| What hour to execute at |
| DOM	  | What day of the month to execute at |
| MON	  | What month of the year to execute at |
| DOW	  | What day of the week to execute at |
| CMD	  | The actual command that will be executed. |

- Let's use the example of backing up files. You may wish to backup "cmnatic"'s  "Documents" every 12 hours. We would use the following formatting: 
  `0 */12 * * * cp -R /home/cmnatic/Documents /var/backups/`

> Package Management

- Removing packages is as easy as reversing. This process is done by using the add-apt-repository --remove ppa:PPA_Name/ppa command or by manually deleting the file that we previously added to. 
- Additional repositories can be added by using the add-apt-repository command.

> System Logs

- Located in the /var/log directory, these files and folders contain logging information for applications and services running on your system.
- The Operating System  (OS) has become pretty good at automatically managing these logs in a process that is known as "rotating".

- The two types of log files below that are of interest:

  - access log
  - error log

![](https://assets.tryhackme.com/additional/linux-fundamentals/part3/log2.png)

- There are, of course, logs that store information about how the OS is running itself and actions that are performed by users, such as authentication attempts.
