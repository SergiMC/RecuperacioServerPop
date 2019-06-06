**Sergi Muñoz Carmona**
**Examen Docker**

## Imatge en Dockerhub:
La imatge es troba en el meu docker sergimc [sergimc](https://hub.docker.com/u/sergimc/)
Redirecció de la imatge 


#Descripció

* POP

**En AWS**
Configurarem els ports de la màquina amazon posant el ipop3 i el imap:
```
POP3 TCP 110 0.0.0.0/0 port pop3
IMAP TCP 143 0.0.0.0/0 port imap
```
Per crear un servidor pop, necessitarem els fitxers:

```
imap
ipop3
ipop2
```
Una vegada configurats, crearem el docker amb la seva imatge corresponent

Primer crearem una network per al docker:
```
[root@ip-172-31-27-73 serverPOP]# docker network create popnet
51bac6665a6a4d10b8e8512a6d69ac49bcf3f9523320fc410d9dc2b66197eca3
```
Creem el docker:
```
[root@ip-172-31-27-73 serverPOP]# docker run --name popserver --hostname popserver --network popnet -p 110:110 -d sergimc/m11sergi:v1
57ea4bb84bb3905cf7e114fd986c8c418118a565ab0cb47c292aa4bdfb80377e
```
Mirem que estigui funcionant
```
[root@ip-172-31-27-73 serverPOP]# docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                  NAMES
57ea4bb84bb3        sergimc/m11sergi:v1   "/opt/docker/start..."   3 seconds ago       Up 1 second         0.0.0.0:110->110/tcp   popserver
```
Farem un nmap per veure si estan oberts els serveis
```
[root@ip-172-31-27-73 serverPOP]#nmap 172.18.0.2

Starting Nmap 7.60 ( https://nmap.org ) at 2019-05-03 10:37 UTC
Nmap scan report for ip-172-18-0-2.eu-west-2.compute.internal (172.18.0.2)
Host is up (0.000014s latency).
Not shown: 995 closed ports
PORT    STATE SERVICE
109/tcp open  pop2
110/tcp open  pop3
143/tcp open  imap
993/tcp open  imaps
995/tcp open  pop3s
MAC Address: 02:42:AC:12:00:02 (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 1.53 seconds

```

**En el nostre host de l'aula farem un telnet per tal de veure si funciona correctament**
Fem el telnet contra la ip de l'amazon i el port 110 (pop)
```
[root@i06 serverPOP]# telnet 18.130.182.206 110
Trying 18.130.182.206...
Connected to 18.130.182.206.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready

**Ens connectem mitjançant el openssl client**
```
root@i06 ~]# openssl s_client -connect 18.130.182.206:110
CONNECTED(00000003)
139952196286272:error:1408F10B:SSL routines:ssl3_get_record:wrong version number:ssl/record/ssl3_record.c:252:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 5 bytes and written 254 bytes
Verification: OK
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : 0000
    Session-ID: 
    Session-ID-ctx: 
    Master-Key: 
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    Start Time: 1556880209
    Timeout   : 7200 (sec)
    Verify return code: 0 (ok)
    Extended master secret: no
---
```

```
* PART POPS

Per crear un servidor pops, necessitarem els fitxers:

```
imap
imaps
ipop3
ipop2
pop3s
```


root@i06 ~]# openssl s_client -connect 18.130.182.206:110








