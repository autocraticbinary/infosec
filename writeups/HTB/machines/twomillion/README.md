# TwoMillion

---

## Recon

### nmap

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    nginx
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

## directory enumeration

```
[01:32:08] 301 -  162B  - /js  ->  http://2million.htb/js/
[01:32:24] 200 -    2KB - /404
[01:32:49] 401 -    0B  - /api
[01:32:50] 401 -    0B  - /api/v1
[01:32:52] 301 -  162B  - /assets  ->  http://2million.htb/assets/
[01:32:52] 403 -  548B  - /assets/
[01:33:06] 403 -  548B  - /controllers/
[01:33:07] 301 -  162B  - /css  ->  http://2million.htb/css/
[01:33:18] 301 -  162B  - /fonts  ->  http://2million.htb/fonts/
[01:33:22] 302 -    0B  - /home  ->  /
[01:33:24] 301 -  162B  - /images  ->  http://2million.htb/images/
[01:33:24] 403 -  548B  - /images/
[01:33:29] 403 -  548B  - /js/
[01:33:33] 200 -    4KB - /login
[01:33:35] 302 -    0B  - /logout  ->  /
[01:34:02] 200 -    4KB - /register
[01:34:32] 301 -  162B  - /views  ->  http://2million.htb/views/

```

> What is the name of the JavaScript file loaded by the /invite page that has to do with invite codes?

`inviteapi.min.js`

> What JavaScript function on the invite page returns the first hint about how to get an invite code? Don't include () in the answer.

`makeInviteCode`

Tool:

https://lelinhtinh.github.io/de4js/

copy

```
eval(function(p,a,c,k,e,d){e=function(c){return
c.toString(36)};if(!''.replace(/^/,String)){while(c--)
{d[c.toString(a)]=k[c]||c.toString(a)}k=[function(e){return d[e]}];e=function()
{return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new
RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('1 i(4){h 8=
{"4":4};$.9({a:"7",5:"6",g:8,b:\'/d/e/n\',c:1(0){3.2(0)},f:1(0){3.2(0)}})}1 j()
{$.9({a:"7",5:"6",b:\'/d/e/k/l/m\',c:1(0){3.2(0)},f:1(0)
{3.2(0)}})}',24,24,'response|function|log|console|code|dataType|json|POST|formData|ajax
|type|url|success|api/v1|invite|error|data|var|verifyInviteCode|makeInviteCode|how|to|g
enerate|verify'.split('|'),0,{}))
```

and paste into de4j and click `Auto Decode`

> The endpoint in makeInviteCode returns encrypted data. That message provides another endpoint to query. That endpoint returns a code value that is encoded with what very common binary to text encoding format. What is the name of that encoding?

`base64`


- `curl -sX POST http://2million.htb/api/v1/invite/how/to/generate | jq`

```
{
  "0": 200,
  "success": 1,
  "data": {
    "data": "Va beqre gb trarengr gur vaivgr pbqr, znxr n CBFG erdhrfg gb /ncv/i1/vaivgr/trarengr",
    "enctype": "ROT13"
  },
  "hint": "Data is encrypted ... We should probbably check the encryption type in order to decrypt it..."
}

```

- `echo "Va beqre gb trarengr gur vaivgr pbqr, znxr n CBFG erdhrfg gb /ncv/i1/vaivgr/trarengr" | /usr/games/rot13`

```
In order to generate the invite code, make a POST request to /api/v1/invite/generate

```

- `curl -X POST http://2million.htb/api/v1/invite/generate`

```
{"0":200,"success":1,"data":{"code":"V1RBWjgtWTBZNUotS1FCUjYtSTdDQUI=","format":"encoded"}}
```

- `echo "V1RBWjgtWTBZNUotS1FCUjYtSTdDQUI=" | base64 -d`

```
WTAZ8-Y0Y5J-KQBR6-I7CAB
```

> What is the path to the endpoint the page uses when a user clicks on "Connection Pack"?

`/api/v1/user/vpn/generate`

