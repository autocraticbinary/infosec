
---

```
/mnt/D8B3
/home/v2Vb
/mnt/c4ZX
/etc/8V2L
/var/FHl1
/opt/oiMO
/opt/PFbD
/media/rmfX
/etc/ssh/SRSq
/var/log/uqyw
/X1Uy
```

> Which of the above files are owned by the best-group group(enter the answer separated by spaces in alphabetical order)

D8B3 v2Vb

`find / -type f -group best-group 2>/dev/null`

> Which of these files contain an IP address?

oiMO

`xargs -a dir -I {} grep -H -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' {}`

> Which file has the SHA1 hash of 9d54da7584015647ba052173b84d45e8007eba94

c4ZX

`xargs -a dir -I {} sha1sum {} | grep 9d54da7584015647ba052173b84d45e8007eba94`

> Which file contains 230 lines?

`xargs -a dir -I {} wc -l {}`

> Which file's owner has an ID of 502?

X1Uy

`xargs -a dir -I {} bash -c 'if [ "$(stat -c "%u" "{}")" -eq 502 ]; then echo "{}"; fi'`

> Which file is executable by everyone?

8V2L

`xargs -a dir -I {} bash -c 'if [ -x "{}" ]; then echo "{}"; fi'`