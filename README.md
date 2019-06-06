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
[root@ip-172-31-18-17 RecuperacioServerPop]# docker run --rm --name servidorpop --hostname servidorpop -p 110:110 -p 995:995 --network popnet -d sergimc/m11extrasergi:v1
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
[isx39449342@i10 RecuperacioServerPop]$ telnet 18.130.106.169 110
Trying 18.130.106.169...
Connected to 18.130.106.169.
Escape character is '^]'.
+OK POP3 servidorpop 2007f.104 server ready

```

**En el nostre host de l'aula farem una connexió amb POPS amb l'usuari marta per tal de veure si funciona
correctament:**

```
[isx39449342@i10 RecuperacioServerPop]$ openssl s_client -connect 18.130.106.169:995
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
MIIETjCCAzagAwIBAgIJAK63O9nsvt4MMA0GCSqGSIb3DQEBCwUAMIG7MQswCQYD
VQQGEwItLTESMBAGA1UECAwJU29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZ
MBcGA1UECgwQU29tZU9yZ2FuaXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXph
dGlvbmFsVW5pdDEeMBwGA1UEAwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJ
KoZIhvcNAQkBFhpyb290QGxvY2FsaG9zdC5sb2NhbGRvbWFpbjAeFw0xOTA2MDYw
ODAxMjlaFw0yMDA2MDUwODAxMjlaMIG7MQswCQYDVQQGEwItLTESMBAGA1UECAwJ
U29tZVN0YXRlMREwDwYDVQQHDAhTb21lQ2l0eTEZMBcGA1UECgwQU29tZU9yZ2Fu
aXphdGlvbjEfMB0GA1UECwwWU29tZU9yZ2FuaXphdGlvbmFsVW5pdDEeMBwGA1UE
AwwVbG9jYWxob3N0LmxvY2FsZG9tYWluMSkwJwYJKoZIhvcNAQkBFhpyb290QGxv
Y2FsaG9zdC5sb2NhbGRvbWFpbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMl6KxQjDHt4uGyyW62w5Xo5a8M5bgNoZWrDOue6+WMKPASFrANe+zypJwMX
dhULxFp3oVyeOD91LLa1ehdMHN8QTeFJQa2cBJ8DHpSnXpycjHC9oerH/56Pv03R
r4EH4bOGP3E4yqAPw6bKUSvEPGD1YWiBn1OS8nzwmBAgaFGLa0QyKj/QCiYW1aEB
P10+f7i12mHSmZbCdrWnXuAA9XT+nObYFmWL2oPuGC6JZrqS2EFr9qb4VK5QDp1O
DSQLJVonciJEKXb16UZ8KECBRCyC+Hx76TJ0AsLWQGbierK0dC4tqsEqM5dnNjO4
H+slXC74j6DOcsUJFoALDYBkr1kCAwEAAaNTMFEwHQYDVR0OBBYEFIBVVfAQmD9x
ThSirME0egDLde+7MB8GA1UdIwQYMBaAFIBVVfAQmD9xThSirME0egDLde+7MA8G
A1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAGqAd6rrmf+A13sBJjx+
9OZvACXI6y0RlkTca/MIXa+zgyODC2K+cvAXa6E94OgjkXJ61FxLEBJ4JmN9yaYt
drNanBOqaDBdLuNE08+1SFIU7sTfvD8t+qQ6/VlT42Xkpb2jm0qmMgOn0ahk4e1D
Q4p5fFe1YYqqSIqSpPJa0aIOqHWx0vPy0hlkX3qTBXH/n4wmQRkWvbeDzhgJil2q
CvIYvEyceGyepeHDBu7yGxv+99qj9VrJAwCP9+HCpDg3EDApUdCOtO+ScRkj3spQ
CHhTJZk9G6e5K7oL2jur6y+nGVcXvCYUb3bfvr3moXjTf5YbFFaZXPV/RYAbGi/2
l+U=
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
    Session-ID: A5B9F85F6DB95FF268BAE042715F235FEFCBDA7C0D3E9850E00D7D10F0A9AD73
    Session-ID-ctx: 
    Master-Key: FB52602D27976B33AE95921C2759D6924E81C09094BF1831197EC18864F16B8C4AD22152F65B4651FB0F4E042171B070
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 7200 (seconds)
    TLS session ticket:
    0000 - 69 af 80 e3 16 c6 24 aa-9f 71 7b 63 a6 7c e0 4f   i.....$..q{c.|.O
    0010 - 41 d1 9c e9 84 46 39 57-ca 06 65 08 51 cb 12 78   A....F9W..e.Q..x
    0020 - d0 e0 48 bd 83 d9 5b ec-69 45 bc 19 1d 6b b4 23   ..H...[.iE...k.#
    0030 - 2c 16 c2 b0 d1 63 7c 41-af da d3 3f 66 81 4f d3   ,....c|A...?f.O.
    0040 - c0 df d2 ff af 4e e9 37-f3 86 54 9a e9 0f c4 a3   .....N.7..T.....
    0050 - ae 98 5a e7 f8 44 06 09-3f 91 cb 2b 2f 43 80 be   ..Z..D..?..+/C..
    0060 - 7d d2 34 18 30 d3 82 d0-28 6d 80 61 f8 08 10 76   }.4.0...(m.a...v
    0070 - 71 b1 e6 64 f5 89 b7 07-9b fe 9f 2f e1 76 04 92   q..d......./.v..
    0080 - 65 3c f0 b6 c2 08 b5 81-66 e1 ca 18 23 a2 1c c2   e<......f...#...
    0090 - 08 81 b1 54 e4 37 08 41-c0 0b f0 67 a2 a3 b4 b8   ...T.7.A...g....

    Start Time: 1559810672
    Timeout   : 7200 (sec)
    Verify return code: 18 (self signed certificate)
    Extended master secret: yes
---
+OK POP3 servidorpop 2007f.104 server ready


```



