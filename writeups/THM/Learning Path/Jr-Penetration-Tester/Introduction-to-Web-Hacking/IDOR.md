# IDOR


**IDOR** stands for **Insecure Direct Object Reference** and is a type of access control vulnerability.

This type of vulnerability can occur when a web server receives user-supplied input to retrieve objects (files, data, documents), too much trust has been placed on the input data, and it is not validated on the server-side to confirm the requested object belongs to the user requesting it.

---

## Finding IDORs in Encoded IDs

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efe36fb68daf465530ca761/room-content/5f2cbe5c4ab4a274420bc9a9afc9202d.png)

---

## Finding IDORs in Hashed Ids


- Little bit more complicated to deal with than encoded ones.
- But they may follow a predictable pattern, such as being the hashed version of the integer value.
- For example, the Id number 123 would become 202cb962ac59075b964b07152d234b70 if md5 hashing were in use.

---

## Finding IDORs in Unpredictable IDs


- If the Id cannot be detected using the above methods, an excellent method of IDOR detection is to create two accounts and swap the Id numbers between them. 
- If you can view the other users' content using their Id number while still being logged in with a different account (or not logged in at all), you've found a valid IDOR vulnerability.

---

## Where are IDORs located


- The vulnerable endpoint you're targeting may not always be something you see in the address bar.
- It could be content your browser loads in via an AJAX request or something that you find referenced in a JavaScript file. 


Sometimes endpoints could have an unreferenced parameter that may have been of some use during development and got pushed to production. For example, you may notice a call to /user/details displaying your user information (authenticated through your session). But through an attack known as **parameter mining**, you discover a parameter called user_id that you can use to display other users' information, for example, /user/details?user_id=123.

---

## Practical


https://10-10-224-13.p.thmlabs.com


Firstly you'll need to log in. To do this, click on the customer's section and create an account. Once logged in, click on the Your Account tab. 


The Your Account section gives you the ability to change your information such as username, email address and password. You'll notice the username and email fields pre-filled in with your information.  


We'll start by investigating how this information gets pre-filled. If you open your browser developer tools, select the network tab and then refresh the page, you'll see a call to an endpoint with the path /api/v1/customer?id={user_id}.


This page returns in JSON format your user id, username and email address. We can see from the path that the user information shown is taken from the query string's id parameter (see below image).

![](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efe36fb68daf465530ca761/room-content/5d71d3fe747a8c8934564feddfc69f75.png)

You can try testing this id parameter for an IDOR vulnerability by changing the id to another user's id. Try selecting users with IDs 1 and 3 and then answer the questions below.

