
---

## level 1 

```
curl http://127.0.0.1:80
```

`pwn.college{ghv-ZiCVpXW16fLmTLZs0GlNMAo.dhjNyMDL3kzM2czW}`

## level 2

```
nc 127.0.0.1 80
	GET / HTTP/1.1
```

## level 3

```
import requests

response = requests.get("http://127.0.0.1:80")
print(response.text)
```

`pwn.college{4935_GC47iYmUs2lZvN5nzgRF9O.dBzNyMDL3kzM2czW}`