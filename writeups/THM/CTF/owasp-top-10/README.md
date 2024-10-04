
---

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


