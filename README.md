Sergi Muñoz Carmona
07/06/2019
Examen Docker
github : https://github.com/SergiMC/RecuperacioServerPop.git

**Sergi Muñoz Carmona**
**Examen Docker recuperació**


## Imatge en Dockerhub:
La imatge es troba en el meu docker sergimc [sergimc](https://hub.docker.com/u/sergimc/)
i la configuració dels fitxer al repositori github [sergimc](https://github.com/SergiMC/RecuperacioServerPop.git)
Redirecció de la imatge 

* POP

**En AWS**
Configurarem els ports de la màquina amazon posant el ipop3 i el imap:
```
POP3 TCP 110 0.0.0.0/0 port pop3
POP3 TCP 995 0.0.0.0/0 port secure pop3
IMAP TCP 143 0.0.0.0/0 port imap
```

Primer crearem una network per al docker:
```
[root@ip-172-31-18-17 fedora]# docker network create popnet
b8a2961549393e8d29f227d86ce62cb6f7e3be897beeb03dace04611eed84e24

```
Creada la network, crearem la imatge amb els fitxers de configuració del servidor pop:

```
[root@ip-172-31-18-17 RecuperacioServerPop]# docker build -t "sergimc/m11extrasergi:v1" .


```
Creem el docker:

```
[root@ip-172-31-18-17 RecuperacioServerPop]# docker run --rm --name popserver --hostname servidorpop -p 110:110 -p 995:995 --network popnet -d sergimc/m11extrasergi:v1
64342998f8f6324d5ae532bd1b915074c331ddc80e82ab8d349e5b0efd80ea3a

```
Asegurem que el docker està funcionant correctament:

```
[root@ip-172-31-18-17 RecuperacioServerPop]# docker ps
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                        NAMES
64342998f8f6        sergimc/m11extrasergi:v1   "/opt/docker/startup…"   2 seconds ago       Up 2 seconds        0.0.0.0:110->110/tcp, 0.0.0.0:995->995/tcp   servidorpop
```

Farem un nmap per veure si estan oberts els serveis:

```
[root@ip-172-31-18-17 RecuperacioServerPop]# nmap localhost

Starting Nmap 7.60 ( https://nmap.org ) at 2019-06-06 08:08 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000080s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 995 closed ports
PORT    STATE SERVICE
7/tcp   open  echo
13/tcp  open  daytime
22/tcp  open  ssh
110/tcp open  pop3
995/tcp open  pop3s

Nmap done: 1 IP address (1 host up) scanned in 1.62 seconds

```
**COMPROVACIONS**

**En el nostre host de l'aula farem un telnet per tal de veure si funciona correctament**
Fem el telnet contra la ip de l'amazon i el port 110 (pop)

```
[isx39449342@i10 tmp]$ telnet 18.130.106.169 110
Trying 18.130.106.169...
Connected to 18.130.106.169.
Escape character is '^]'.
+OK POP3 popserver 2007f.104 server ready
USER pere
+OK User name accepted, password please
PASS pere
+OK Mailbox open, 1 messages
LIST
+OK Mailbox scan listing follows
1 167
.
RETR 1
+OK 167 octets
Received: from ... by ... with ESMTP;
Subject: Prova
From: <pere@edt-orgcom>
To: <junkdtectr@carolina.rr.com>
Status: RO

>Bon dia avui tenim examen :att pere.
.
QUIT
+OK Sayonara
Connection closed by foreign host.

```

**En el nostre host de l'aula farem una connexió amb POPS amb l'usuari marta per tal de veure si funciona
correctament:**

```
[isx39449342@i10 tmp]$ openssl s_client -connect 18.130.106.169:995
CONNECTED(00000003)
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify error:num=18:self signed certificate
verify return:1
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify return:1
---
Certificate chain
 0 s:/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
   i:/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIETjCCAzagAwIBAgIJALD90MvTePXSMA0GCSqGSIb3DQEBCwUAMIG7MQswCQYD
VQQGEwItLTESMBAGA1UECAwJU29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZ
MBcGA1UECgwQU29tZU9yZ2FuaXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXph
dGlvbmFsVW5pdDEeMBwGA1UEAwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJ
KoZIhvcNAQkBFhpyb290QGxvY2FsaG9zdC5sb2NhbGRvbWFpbjAeFw0xOTA2MDYw
OTQ2NDJaFw0yMDA2MDUwOTQ2NDJaMIG7MQswCQYDVQQGEwItLTESMBAGA1UECAwJ
U29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZMBcGA1UECgwQU29tZU9yZ2Fu
aXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXphdGlvbmFsVW5pdDEeMBwGA1UE
AwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJKoZIhvcNAQkBFhpyb290QGxv
Y2FsaG9zdC5sb2NhbGRvbWFpbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMbCcEfKBwpB8547WGcCGFRp2q5NpDm+kPxcqGFpGoEmM9q89cEI6CcJmxVk
hOyeSsz/Z6/W/UNwbNkRyM3mRfgnJj32k6Yiljv+KoaBnQVodxVMbGd912OJkry1
NdNcf6i6eAxEVlaz4id34TZeb6H04WrIdMg00xtfLKeo1vitHN43blzJ3BmrC+W9
J31XBBLx7sXBiJeYDYuXOf5TAv6a+14sSPLiSq0cR8/XXZD9NuBdXS/D5hNynQeP
i14TdrcJ3Qx8F3uoEltOWt5Wl2beX6UmFiF6qQLcxharNSgyc9vDWDyCQsUgp1eR
TJ/1Y71DxvL9ozpWS5YepHiyOEsCAwEAAaNTMFEwHQYDVR0OBBYEFJcjgWC2u/x0
YVbimUqrBhx7q6QaMB8GA1UdIwQYMBaAFJcjgWC2u/x0YVbimUqrBhx7q6QaMA8G
A1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBABJOvYmKLdrU2uAnZ79J
TzzmWW1p+LCuXPUF2zdwyetMZO9bKZ45OTaQ3wF7BA6aKYGEVqt6E9xHVIX8PZHD
1YXP7nfNl6c5GrKqOsHWRBWmW+X9qHO3ioUo1v74yPhrkaDEfUkWyTv3NNeFEp7j
rH0Kq2qugsEWa3zU+YtjSOPqq2y1RQwL72yOxgv5n1oFmcj85zlP6dccIVeNCbQL
IJsa1VpLS5Uxgcv7RhrkViB0VZCzKoSgYNSXHPPuT21th/rhHRRv7ktPGwqwk9e8
I7FBVSVnl30gjGFq1VBxhwyNkFr3XSYw+dSIO1Lrxc7+CfHNMZNjd1q62AoyeV1L
P88=
-----END CERTIFICATE-----
subject=/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
issuer=/C=--/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: X25519, 253 bits
---
SSL handshake has read 1731 bytes and written 347 bytes
Verification error: self signed certificate
---
New, TLSv1.2, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: E7B602C9A6C6DE18AB087D470D551C3CFAB8346D111D7A6D59C1ACEDDFFD7A9E
    Session-ID-ctx: 
    Master-Key: 8D957742D23C702EA2368FC0468B62B6B4B6CAF99DBA89780C75306B86ABD2BF9C5BB414D3FD2C89268B7084B36DB36B
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 7200 (seconds)
    TLS session ticket:
    0000 - 49 a2 5a 99 42 b0 ef 12-97 87 3e 06 dc 62 44 69   I.Z.B.....>..bDi
    0010 - 1e ee 06 75 ce a2 bc c4-7a 81 8f fe 69 be 12 c6   ...u....z...i...
    0020 - 10 d5 d6 ae bb e5 0a 9c-b8 5f 3d 03 35 09 a1 8a   ........._=.5...
    0030 - 36 33 94 0c b8 b8 dc 96-68 8f 02 35 86 98 68 d9   63......h..5..h.
    0040 - 76 49 26 4a 7c 7d 5b 6c-87 3f 09 55 03 58 05 d0   vI&J|}[l.?.U.X..
    0050 - 1b 0f 4f af cf 6c c1 d0-62 b7 98 17 81 56 b0 3f   ..O..l..b....V.?
    0060 - d6 a4 03 13 9a 9c a5 6e-16 57 98 4e c5 51 21 d1   .......n.W.N.Q!.
    0070 - a0 a2 38 98 04 86 2f b2-47 71 10 f1 97 38 50 d6   ..8.../.Gq...8P.
    0080 - 10 9c a5 b4 45 d8 40 ee-b3 48 c2 eb 95 68 a7 e5   ....E.@..H...h..
    0090 - df 19 dc 85 96 43 33 81-95 e3 56 74 58 c1 01 1c   .....C3...VtX...

    Start Time: 1559814927
    Timeout   : 7200 (sec)
    Verify return code: 18 (self signed certificate)
    Extended master secret: yes
---
+OK POP3 popserver 2007f.104 server ready
USER marta
+OK User name accepted, password please
PASS marta
+OK Mailbox open, 1 messages
LIST
+OK Mailbox scan listing follows
1 171
.
RETR 1
RENEGOTIATING
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify error:num=18:self signed certificate
verify return:1
depth=0 C = --, ST = SomeState, L = SomeCity, O = SomeOrganization, OU = SomeOrganizationalUnit, CN = localhost.localdomain, emailAddress = root@localhost.localdomain
verify return:1
quit
+OK Sayonara
read:errno=0

```



