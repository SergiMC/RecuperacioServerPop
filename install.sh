#! /bin/bash
# @edt ASIX Sergi Muñoz Carmona
# install.sh
#---------------------------------

#Creem els usuaris
useradd marta
useradd pere
echo "marta" | passwd --stdin marta
echo "pere" | passwd --stdin pere

#Copiem fitxers

cp /opt/docker/ipop3 /etc/xinetd.d/ipop3
cp /opt/docker/pop3s /etc/xinetd.d/pop3s

#Creem correu
cp /opt/docker/marta /var/spool/mail/marta
cp /opt/docker/pere /var/spool/mail/pere

#Donem els permissos
chown -R marta.marta /var/spool/mail/marta
chown -R pere.pere /var/spool/mail/pere






