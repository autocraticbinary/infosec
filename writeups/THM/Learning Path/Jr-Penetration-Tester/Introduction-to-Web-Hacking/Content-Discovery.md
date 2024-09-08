# Content Discovery

---

> Content

This content could be, for example, pages or portals intended for staff usage, older versions of the website, backup files, configuration files, administration panels, etc.

- There are three main ways of discovering content on a website.
	- Manually
	- Automated
	- OSINT (Open-Source Intelligence).

---

## Manual Discovery

There are multiple places we can manually check on a website to start discovering more content. 

### Robots.txt

The robots.txt file is a document that tells search engines which pages they are and aren't allowed to show on their search engine results or ban specific search engines from crawling the website altogether.

`http://ip/robots.txt`


### Favicon

The favicon is a small icon displayed in the browser's address bar or tab used for branding a website.

- Sometimes when frameworks are used to build a website, a favicon that is part of the installation gets leftover, and if the website developer doesn't replace this with a custom one, this can give us a clue on what framework is in use.
- OWASP host a database of common framework icons that you can use to check against the targets favicon https://wiki.owasp.org/index.php/OWASP_favicon_database.

- The page source will contains a link to the images/favicon.ico file


- Steps
	- Get md5 hash of favicon
		bash:

		```
		user@machine$ curl https://static-labs.tryhackme.cloud/sites/favicon/images/favicon.ico | md5sum
        ```

		powershell:

		```
		PS C:\> curl https://static-labs.tryhackme.cloud/sites/favicon/images/favicon.ico -UseBasicParsing -o favicon.ico
		PS C:\> Get-FileHash .\favicon.ico -Algorithm MD5
		```
	- Check in https://wiki.owasp.org/index.php/OWASP_favicon_database


### Sitemap.xml

Unlike the robots.txt file, which restricts what search engine crawlers can look at, the sitemap.xml file gives a list of every file the website owner wishes to be listed on a search engine.

- These can sometimes contain areas of the website that are a bit more difficult to navigate to or even list some old webpages that the current site no longer uses but are still working behind the scenes.

`http://ip/sitemap.xml`


### HTTP Headers

- When we make requests to the web server, the server returns various HTTP headers. 

ex:
`user@machine$ curl http://ip -v`


### Framework Stack

Once you've established the framework of a website, either from the above favicon example or by looking for clues in the page source such as comments, copyright notices or credits, you can then locate the framework's website. From there, we can learn more about the software and other information, possibly leading to more content we can discover.

- Check
	- Documentation
	- Change Logs
	- News

---

## OSINT

There are also external resources available that can help in discovering information about your target website; these resources are often referred to as OSINT or (Open-Source Intelligence) as they're freely available tools that collect information:


### Google Hacking / Dorking

Google hacking / Dorking utilizes Google's advanced search engine features, which allow you to pick out custom content.

Some of the filters are:

**site**
	Example :- site:tryhackme.com
	Description :- returns results only from the specified website address
**inurl**
	Example :- inurl:admin
	Description :- returns results that have the specified word in the URL
**filetype**
	Example :- filetype:pdf
	Description :- returns results which are a particular file extension
**intitle**
	Example :- intitle:admin
	Description :- returns results that contain the specified word in the title


### Wappalyzer

Wappalyzer (https://www.wappalyzer.com/) is an online tool and browser extension that helps identify what technologies a website uses, such as frameworks, Content Management Systems (CMS), payment processors and much more, and it can even find version numbers as well.


### Wayback Machine

The Wayback Machine (https://archive.org/web/) is a historical archive of websites that dates back to the late 90s. You can search a domain name, and it will show you all the times the service scraped the web page and saved the contents. This service can help uncover old pages that may still be active on the current website.


### GitHub

- Git is a version control system that tracks changes to files in a project.
- GitHub is a hosted version of Git on the internet.

- You can use GitHub's search feature to look for company names or website names to try and locate repositories belonging to your target. Once discovered, you may have access to source code, passwords or other content that you hadn't yet found.


### S3 Buckets

S3 Buckets are a storage service provided by Amazon AWS, allowing people to save files and even static website content in the cloud accessible over HTTP and HTTPS.

- The owner of the files can set access permissions to either make files public, private and even writable. Sometimes these access permissions are incorrectly set and inadvertently allow access to files that shouldn't be available to the public.
- The format of the S3 buckets is http(s)://{name}.s3.amazonaws.com where {name} is decided by the owner, such as tryhackme-assets.s3.amazonaws.com. 

- S3 buckets can be discovered in many ways, such as finding the URLs in the website's page source, GitHub repositories, or even automating the process.
- One common automation method is by using the company name followed by common terms such as {name}-assets, {name}-www, {name}-public, {name}-private, etc.

---

## Automated Discovery

- Automated discovery is the process of using tools to discover content rather than doing it manually.
- Wordlists are just text files that contain a long list of commonly used words; they can cover many different use cases.

- examples :

Using ffuf:

```           
user@machine$ ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt -u http://10.10.111.19/FUZZ
```

Using dirb:

```         
user@machine$ dirb http://10.10.111.19/ /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
```
 
Using Gobuster:

```
user@machine$ gobuster dir --url http://10.10.111.19/ -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
```     

