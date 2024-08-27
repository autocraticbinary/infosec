# Operating System Security

---

we will focus on three weaknesses targeted by malicious users:

    Authentication and Weak Passwords
    Weak File Permissions
    Malicious Programs

>  Authentication and Weak Passwords

Authentication is the act of verifying your identity, be it a local or a remote system. Authentication can be achieved via three main ways:

  - Something you know, such as a password or a PIN code.
  - Something you are, such as a fingerprint.
  - Something you have, such as a phone number via which you can receive an SMS message.

> Weak File Permissions

Proper security dictates the principle of least privilege. In a work environment, you want any file accessible only by those who need to access it to get work done. On a personal level, if you are planning a trip with family or friends, you might want to share all the files related to the trip plan with those going on that trip; you don’t want to share such files publicly. That’s the principle of least privilege, or in simpler terms, “who can access what?”

Weak file permissions make it easy for the adversary to attack confidentiality and integrity. They can attack confidentiality as weak permissions allow them to access files they should not be able to access. Moreover, they can attack integrity as they might modify files that they should not be able to edit.

> Access to Malicious Programs

The last example we will consider is the case of malicious programs. Depending on the type of malicious program, it can attack confidentiality, integrity, and availability.

Some types of malicious programs, such as Trojan horses, give the attacker access to your system. Consequently, the attacker would be able to read your files or even modify them.

Some types of malicious programs attack availability. One such example is ransomware. Ransomware is a malicious program that encrypts the user's files. Encryption makes the file(s) unreadable without knowing the encryption password; in other words, the files become gibberish without decryption (reversing the encryption). The attacker offers the user the ability to restore availability, i.e., regain access to their original files: they would give them the encryption password if the user is willing to pay the “ransom.”


