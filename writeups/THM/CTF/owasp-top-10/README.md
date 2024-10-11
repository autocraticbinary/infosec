
---

## [Severity 1] Injection
## [Severity 2] Broken Authentication


- Authentication allows users to gain access to web applications by verifying their identities.
- The most common form of authentication is using a username and password mechanism. A user would enter these credentials, the server would verify them. If they are correct, the server would then provide the users’ browser with a session cookie. A session cookie is needed because web servers use HTTP(S) to communicate which is stateless. Attaching session cookies means that the server will know who is sending what data. The server can then keep track of users' actions.

Some common flaws in authentication mechanisms include: 

- Brute force attacks: If a web application uses usernames and passwords, an attacker is able to launch brute force attacks that allow them to guess the username and passwords using multiple authentication attempts. 
- Use of weak credentials: web applications should set strong password policies. If applications allow users to set passwords such as ‘password1’ or common passwords, then an attacker is able to easily guess them and access user accounts. They can do this without brute forcing and without multiple attempts.
- Weak Session Cookies: Session cookies are how the server keeps track of users. If session cookies contain predictable values, an attacker can set their own session cookies and access users’ accounts.

There can be various mitigation for broken authentication mechanisms depending on the exact flaw:

- To avoid password guessing attacks, ensure the application enforces a strong password policy. 
- To avoid brute force attacks, ensure that the application enforces an automatic lockout after a certain number of attempts. This would prevent an attacker from launching more brute force attacks.
- Implement Multi Factor Authentication - If a user has multiple methods of authentication, for example, using username and passwords and receiving a code on their mobile device, then it would be difficult for an attacker to get access to both credentials to get access to their account.


Example:

A lot of times what happens is that developers forgets to sanitize the input(username & password) given by the user in the code of their application, which can make them vulnerable to attacks like SQL injection. However, we are going to focus on a vulnerability that happens because of a developer's mistake but is very easy to exploit i.e re-registration of an existing user.

Let's understand this with the help of an example, say there is an existing user with the name admin and now we want to get access to their account so what we can do is try to re-register that username but with slight modification. We are going to enter " admin"(notice the space in the starting). Now when you enter that in the username field and enter other required information like email id or password and submit that data. It will actually register a new user but that user will have the same right as normal admin. That new user will also be able to see all the content presented under the user admin.

To see this in action go to [http://10.10.14.35:8888](http://10.10.14.35:8888) and try to register a user name darren, you'll see that user already exists so then try to register a user " darren" and you'll see that you are now logged in and will be able to see the content present only in Darren's account which in our case is the flag that you need to retrieve.

---

## [Severity 3] Sensitive Data Exposure


#### Introduction

- When a webapp accidentally divulges sensitive data, we refer to it as "Sensitive Data Exposure".

This is often data directly linked to customers (e.g. names, dates-of-birth, financial information, etc), but could also be more technical information, such as usernames and passwords. At more complex levels this often involves techniques such as a "Man in The Middle Attack", whereby the attacker would force user connections through a device which they control, then take advantage of weak encryption on any transmitted data to gain access to the intercepted information (if the data is even encrypted in the first place...). Of course, many examples are much simpler, and vulnerabilities can be found in web apps which can be exploited without any advanced networking knowledge. Indeed, in some cases, the sensitive data can be found directly on the webserver itself...

#### Supporting Material 1

- Databases can also be stored as files. These databases are referred to as "flat-file" databases, as they are stored as a single file on the computer.
- The most common (and simplest) format of flat-file database is an _sqlite_ database.
- Client : `sqlite3`

sqlite3 commands:

- To access it we use: `sqlite3 <database-name>`
- To see the tables in the database by using the `.tables` command.
- First let's use `PRAGMA table_info(customers);` to see the table information.
- Then we'll use `SELECT * FROM <table-name>;` to dump the information from the table

---

## [Severity 4] XML External Entity


- An XML External Entity (XXE) attack is a vulnerability that abuses features of XML parsers/data.
- It often allows an attacker to interact with any backend or external systems that the application itself can access and can allow the attacker to read the file on that system.
- They can also cause Denial of Service (DoS) attack or could use XXE to perform Server-Side Request Forgery (SSRF) inducing the web application to make requests to other applications. XXE may even enable port scanning and lead to remote code execution.

There are two types of XXE attacks: in-band and out-of-band (OOB-XXE). 
1) An in-band XXE attack is the one in which the attacker can receive an immediate response to the XXE payload.

2) out-of-band XXE attacks (also called blind XXE), there is no immediate response from the web application and attacker has to reflect the output of their XXE payload to some other file or their own server.

#### eXtensible Markup Language

**What is XML?**  
  
XML (eXtensible Markup Language) is a markup language that defines a set of rules for encoding documents in a format that is both human-readable and machine-readable. It is a markup language used for storing and transporting data.   
  
**Why we use XML?**  
  
1. XML is platform-independent and programming language independent, thus it can be used on any system and supports the technology change when that happens.  
  
2. The data stored and transported using XML can be changed at any point in time without affecting the data presentation.  
  
3. XML allows validation using DTD and Schema. This validation ensures that the XML document is free from any syntax error.  
  
4. XML simplifies data sharing between various systems because of its platform-independent nature. XML data doesn’t require any conversion when transferred between different systems.  
  
**Syntax**  
  
Every XML document mostly starts with what is known as XML Prolog.  
  
`<?xml version="1.0" encoding="UTF-8"?>`

  
Above the line is called XML prolog and it specifies the XML version and the encoding used in the XML document. This line is not compulsory to use but it is considered a `good practice` to put that line in all your XML documents.  
  
Every XML document must contain a `ROOT` element. For example:  

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mail>
	<to>falcon</to>
	<from>feast</from>
	<subject>About XXE</subject>
	<text>Teach about XXE</text>
</mail>
```
  
In the above example the `<mail>` is the ROOT element of that document and `<to>`, `<from>`, `<subject>`, `<text>` are the children elements. If the XML document doesn't have any root element then it would be considered`wrong` or `invalid` XML doc.  
  
Another thing to remember is that XML is a case sensitive language. If a tag starts like `<to>` then it has to end by `</to>` and not by something like `</To>`(notice the capitalization of `T`)  
  
Like HTML we can use attributes in XML too. The syntax for having attributes is also very similar to HTML. For example:  
`<text category = "message">You need to learn about XXE</text>   `

In the above example `category` is the attribute name and `message` is the attribute value.

#### DTD

- DTD stands for Document Type Definition. A DTD defines the structure and the legal elements and attributes of an XML document.

Let us try to understand this with the help of an example. Say we have a file named `note.dtd` with the following content:  

`<!DOCTYPE note [ <!ELEMENT note (to,from,heading,body)> <!ELEMENT to (#PCDATA)> <!ELEMENT from (#PCDATA)> <!ELEMENT heading (#PCDATA)> <!ELEMENT body (#PCDATA)> ]>`  

Now we can use this DTD to validate the information of some XML document and make sure that the XML file conforms to the rules of that DTD.

Ex: Below is given an XML document that uses `note.dtd`

```
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE note SYSTEM "note.dtd">  
<note>  
    <to>falcon</to>  
    <from>feast</from>  
    <heading>hacking</heading>  
    <body>XXE attack</body>  
</note>
```  

So now let's understand how that DTD validates the XML. Here's what all those terms used in `note.dtd` mean  

- !DOCTYPE note -  Defines a root element of the document named note
- !ELEMENT note - Defines that the note element must contain the elements: "to, from, heading, body"
- !ELEMENT to - Defines the `to` element to be of type "#PCDATA"
- !ELEMENT from - Defines the `from` element to be of type "#PCDATA"
- !ELEMENT heading  - Defines the `heading` element to be of type "#PCDATA"
- !ELEMENT body - Defines the `body` element to be of type "#PCDATA"

    NOTE: "#PCDATA" means parseable character data.

> define a new ELEMENT?

`!ELEMENT`

> define a ROOT element?

`!DOCTYPE`

> define a new ENTITY?

`!ENTITY`

#### XXE Payload

Some XXE payload:

1) The first payload we'll see is very simple. If you've read the previous task properly then you'll understand this payload very easily.  

```  
<!DOCTYPE replace [<!ENTITY name "feast"> ]>
<userInfo>
	<firstName>falcon</firstName>
	<lastName>&name;</lastName>
</userInfo>

```
  
As we can see we are defining a `ENTITY` called `name` and assigning it a value `feast`. Later we are using that ENTITY in our code.  

2) We can also use XXE to read some file from the system by defining an ENTITY and having it use the SYSTEM keyword  

```
<?xml version="1.0"?>
<!DOCTYPE root [<!ENTITY read SYSTEM 'file:///etc/passwd'>]>
<root>&read;</root>

```
  
Here again, we are defining an ENTITY with the name `read` but the difference is that we are setting it value to `SYSTEM` and path of the file.  
  
If we use this payload then a website vulnerable to XXE(normally) would display the content of the file `/etc/passwd`.

In a similar manner, we can use this kind of payload to read other files but a lot of times you can fail to read files in this manner or the reason for failure could be the file you are trying to read.

#### Exploiting

Now let us see some payloads in action. The payload that I'll be using is the one we saw in the previous task.

1) Let's see how the website would look if we'll try to use the payload for displaying the name.

![](https://i.imgur.com/OHXXxi4.png)  

On the left side, we can see the burp request that was sent with the URL encoded payload and on the right side we can see that the payload was able to successfully display name `falcon feast`

2) Now let's try to read the `/etc/passwd`

![](https://i.imgur.com/092GSLz.png)

---

## [Severity 5] Broken Access Control


Websites have pages that are protected from regular visitors, for example only the site's admin user should be able to access a page to manage other users. If a website visitor is able to access the protected page/pages that they are not authorised to view, the access controls are broken.

A regular visitor being able to access protected pages, can lead to the following:

- Being able to view sensitive information
- Accessing unauthorized functionality

OWASP have a listed a few attack scenarios demonstrating access control weaknesses:  

**Scenario #1**: The application uses unverified data in a SQL call that is accessing account information:

```
pstmt.setString(1, request.getParameter("acct"));
ResultSet results = pstmt.executeQuery( );
```
  
An attacker simply modifies the ‘acct’ parameter in the browser to send whatever account number they want. If not properly verified, the attacker can access any user’s account.

http://example.com/app/accountInfo?acct=notmyacct

**Scenario #2**: An attacker simply force browses to target URLs. Admin rights are required for access to the admin page.

http://example.com/app/getappInfo
http://example.com/app/admin_getappInfo

If an unauthenticated user can access either page, it’s a flaw. If a non-admin can access the admin page, this is a flaw ([reference to scenarios](https://owasp.org/www-project-top-ten/OWASP_Top_Ten_2017/Top_10-2017_A5-Broken_Access_Control)).

To put simply, broken access control allows attackers to bypass authorization which can allow them to view sensitive data or perform tasks as if they were a privileged user.

#### IDOR Challenge

IDOR, or Insecure Direct Object Reference, is the act of exploiting a misconfiguration in the way user input is handled, to access resources you wouldn't ordinarily be able to access. IDOR is a type of access control vulnerability.

`https://example.com/bank?account_number=1234`

There is however a potentially huge problem here, a hacker may be able to change the account_number parameter to something else like 1235, and if the site is incorrectly configured, then he would have access to someone else's bank information.

---

## [Severity 6] Security Misconfiguration

Security Misconfigurations are distinct from the other Top 10 vulnerabilities, because they occur when security could have been configured properly but was not.  

Security misconfigurations include:

- Poorly configured permissions on cloud services, like S3 buckets
- Having unnecessary features enabled, like services, pages, accounts or privileges
- Default accounts with unchanged passwords
- Error messages that are overly detailed and allow an attacker to find out more about the system
- Not using [HTTP security headers](https://owasp.org/www-project-secure-headers/), or revealing too much detail in the Server: HTTP header

This vulnerability can often lead to more vulnerabilities, such as default credentials giving you access to sensitive data, XXE or command injection on admin pages.

---

## [Severity 7] Cross-Site Scripting

Cross-site scripting, also known as XSS is a security vulnerability typically found in web applications. It’s a type of injection which can allow an attacker to execute malicious scripts and have it execute on a victim’s machine.

A web application is vulnerable to XSS if it uses unsanitized user input. XSS is possible in Javascript, VBScript, Flash and CSS. There are three main types of cross-site scripting:

1. Stored XSS - the most dangerous type of XSS. This is where a malicious string originates from the website’s database. This often happens when a website allows user input that is not sanitised (remove the "bad parts" of a users input) when inserted into the database.
2. Reflected XSS - the malicious payload is part of the victims request to the website. The website includes this payload in response back to the user. To summarise, an attacker needs to trick a victim into clicking a URL to execute their malicious payload.
3. DOM-Based XSS - DOM stands for Document Object Model and is a programming interface for HTML and XML documents. It represents the page so that programs can change the document structure, style and content. A web page is a document and this document can be either displayed in the browser window or as the HTML source.
#### XSS Payloads

Remember, cross-site scripting is a vulnerability that can be exploited to execute malicious Javascript on a victim’s machine. Check out some common payloads types used:

- Popup's (<script>alert(“Hello World”)</script>) - Creates a Hello World message popup on a users browser.
- Writing HTML (document.write) - Override the website's HTML to add your own (essentially defacing the entire page).
- XSS Keylogger (http://www.xss-payloads.com/payloads/scripts/simplekeylogger.js.html) - You can log all keystrokes of a user, capturing their password and other sensitive information they type into the webpage.
- Port scanning (http://www.xss-payloads.com/payloads/scripts/portscanapi.js.html) - A mini local port scanner (more information on this is covered in the TryHackMe XSS room).

XSS-Payloads.com (http://www.xss-payloads.com/) is a website that has XSS related Payloads, Tools, Documentation and more. You can download XSS payloads that take snapshots from a webcam or even get a more capable port and network scanner.

- `<script>document.querySelector('#thm-title').textContent = 'I am a hacker'</script>`

- `<script>alert(window.location.hostname)</script>`

---

## [Severity 8] Insecure Deserialization

- Simply, insecure deserialization is replacing data processed by an application with malicious code; allowing anything from DoS (Denial of Service) to RCE (Remote Code Execution) that the attacker can use to gain a foothold in a pentesting scenario.
- Specifically, this malicious code leverages the legitimate serialization and deserialization process used by web applications.

- Low exploitability. This vulnerability is often a case-by-case basis - there is no reliable tool/framework for it. Because of its nature, attackers need to have a good understanding of the inner-workings of the ToE.
- The exploit is only as dangerous as the attacker's skill permits, more so, the value of the data that is exposed. For example, someone who can only cause a DoS will make the application unavailable. The business impact of this will vary on the infrastructure - some organisations will recover just fine, others, however, will not.

**What's Vulnerable?**

At summary, ultimately, any application that stores or fetches data where there are no validations or integrity checks in place for the data queried or retained. A few examples of applications of this nature are:

- E-Commerce Sites  
- Forums  
- API's  
- Application Runtimes (Tomcat, Jenkins, Jboss, etc)

﻿**Objects**

A prominent element of object-oriented programming (OOP), objects are made up of two things:

- State
- Behaviour

Simply, objects allow you to create similar lines of code without having to do the leg-work of writing the same lines of code again.

For example, a lamp would be a good object. Lamps can have different types of bulbs, this would be their state, as well as being either on/off - their behaviour!
Rather than having to accommodate every type of bulb and whether or not that specific lamp is on or off, you can use methods to simply alter the state and behaviour of the lamp.

**De(Serialization)**

_Learning is best done through analogies_

A Tourist approaches you in the street asking for directions. They're looking for a local landmark and got lost. Unfortunately, English isn't their strong point and nor do you speak their dialect either. What do you do? You draw a map of the route to the landmark because pictures cross language barriers, they were able to find the landmark. Nice! You've just serialised some information, where the tourist then deserialised it to find the landmark.

**Continued**

Serialisation is the process of converting objects used in programming into simpler, compatible formatting for transmitting between systems or networks for further processing or storage.

Alternatively, deserialisation is the reverse of this; converting serialised information into their complex form - an object that the application will understand.

**What does this mean?**

Say you have a password of "password123" from a program that needs to be stored in a database on another system. To travel across a network this string/output needs to be converted to binary. Of course, the password needs to be stored as "password123" and not its binary notation. Once this reaches the database, it is converted or deserialised back into "password123" so it can be stored.

_The process is best explained through diagrams:_

![](https://i.imgur.com/ZB76mLI.png)  

**How can we leverage this?**

Simply, insecure deserialization occurs when data from an untrusted party (I.e. a hacker) gets executed because there is no filtering or input validation; the system assumes that the data is trustworthy and will execute it no holds barred.

**Cookies 101**

Ah yes, the origin of many memes. Cookies are an essential tool for modern websites to function. Tiny pieces of data, these are created by a website and stored on the user's computer. 

![](https://i.imgur.com/phg51EI.png)

You'll see notifications like the above on most websites these days. Websites use these cookies to store user-specific behaviours like items in their shopping cart or session IDs.

In the web application, we're going to exploit, you'll notice cookies store login information like the below! Yikes!

  

![](https://i.imgur.com/QhR7aOX.png)

Whilst plaintext credentials is a vulnerability in itself, it is not insecure deserialization as we have not sent any serialized data to be executed!

Cookies are not permanent storage solutions like databases. Some cookies such as session ID's will clear when the browser is closed, others, however, last considerably longer. This is determined by the "Expiry" timer that is set when the cookie is created.

_Some cookies have additional attributes, a small list of these are below:_

| Attribute    | Description                                                             | Required? |
| ------------ | ----------------------------------------------------------------------- | --------- |
| Cookie Name  | The Name of the Cookie to be set                                        | Yes       |
| Cookie Value | Value, this can be anything plaintext or encoded                        | Yes       |
| Secure Only  | If set, this cookie will only be set over HTTPS connections             | No        |
| Expiry       | Set a timestamp where the cookie will be removed from the browser       | No        |
| Path         | The cookie will only be sent if the specified URL is within the request | No        |

﻿**Creating Cookies**

Cookies can be set in various website programming languages. For example, Javascript, PHP or Python to name a few. The following web application is developed using Python's Flask, so it is fitting to use it as an example.

_Take the snippet below:_

![](https://i.imgur.com/9WOYwbF.png)  

Setting cookies in Flask is rather trivial. Simply, this snippet gets the current date and time, stores it within the variable "timestamp" and then stores the date and time in a cookie named "registrationTimestamp". This is what it will look like in the browser.

![](https://i.imgur.com/I4oUGsn.png)  

_It's as simple as that._

Reference : `pickle` — Python object serialization

---

## [Severity 9] Components With Known Vulnerabilities

---

## [Severity 10] Insufficient Logging and Monitoring

When web applications are set up, every action performed by the user should be logged. Logging is important because in the event of an incident, the attackers actions can be traced. Once their actions are traced, their risk and impact can be determined. Without logging, there would be no way to tell what actions an attacker performed if they gain access to particular web applications. The bigger impacts of these include:

- regulatory damage: if an attacker has gained access to personally identifiable user information and there is no record of this, not only are users of the application affected, but the application owners may be subject to fines or more severe actions depending on regulations.
- risk of further attacks: without logging, the presence of an attacker may be undetected. This could allow an attacker to launch further attacks against web application owners by stealing credentials, attacking infrastructure and more.

The information stored in logs should include:

- HTTP status codes
- Time Stamps
- Usernames
- API endpoints/page locations
- IP addresses

These logs do have some sensitive information on them so its important to ensure that logs are stored securely and multiple copies of these logs are stored at different locations.

As you may have noticed, logging is more important after a breach or incident has occurred. The ideal case is having monitoring in place to detect any suspicious activity. The aim of detecting this suspicious activity is to either stop the attacker completely or reduce the impact they've made if their presence has been detected much later than anticipated. Common examples of suspicious activity includes:

- multiple unauthorised attempts for a particular action (usually authentication attempts or access to unauthorised resources e.g. admin pages)
- requests from anomalous IP addresses or locations: while this can indicate that someone else is trying to access a particular user's account, it can also have a false positive rate.
- use of automated tools: particular automated tooling can be easily identifiable e.g. using the value of User-Agent headers or the speed of requests. This can indicate an attacker is using automated tooling.
- common payloads: in web applications, it's common for attackers to use Cross Site Scripting (XSS) payloads. Detecting the use of these payloads can indicate the presence of someone conducting unauthorised/malicious testing on applications.

Just detecting suspicious activity isn't helpful. This suspicious activity needs to be rated according to the impact level. For example, certain actions will higher impact than others. These higher impact actions need to be responded to sooner thus they should raise an alarm which raises the attention of the relevant party.