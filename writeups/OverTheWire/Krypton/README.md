
----
`krypton1:KRYPTONISGREAT`
### Krypton 1

```
krypton1@bandit:~$ ls
krypton1@bandit:~$ cd /krypton/
krypton1@bandit:/krypton$ ls
krypton1  krypton2  krypton3  krypton4  krypton5  krypton6  krypton7
krypton1@bandit:/krypton$ cd krypton1/
krypton1@bandit:/krypton/krypton1$ ls
krypton2  README
krypton1@bandit:/krypton/krypton1$ cat krypton2
YRIRY GJB CNFFJBEQ EBGGRA
krypton1@bandit:/krypton/krypton1$
```

```
fc@core:~$ echo "YRIRY GJB CNFFJBEQ EBGGRA" | rot13
LEVEL TWO PASSWORD ROTTEN
```

### Krypton 2

```
krypton2@melinda:~$ mktemp -d
/tmp/tmp.kj5PEc7wo8
krypton2@melinda:~$ cd /tmp/tmp.kj5PEc7wo8
krypton2@melinda:/tmp/tmp.kj5PEc7wo8$ ln -s /krypton/krypton2/keyfile.dat
krypton2@melinda:/tmp/tmp.kj5PEc7wo8$ ls
keyfile.dat
krypton2@melinda:/tmp/tmp.kj5PEc7wo8$ chmod 777 .
krypton2@melinda:/tmp/tmp.kj5PEc7wo8$ /krypton/krypton2/encrypt /krypton/krypton2/krypton3
krypton2@melinda:/tmp/tmp.kj5PEc7wo8$ ls
ciphertext  keyfile.dat
krypton2@bandit:/tmp/tmp.kj5PEc7wo8$ cat ciphertext
AYCQYPGQCYQW
krypton2@bandit:/tmp/tmp.kj5PEc7wo8$
```

- https://www.dcode.fr/caesar-cipher

`CAESARISEASY`

### Krypton 3

