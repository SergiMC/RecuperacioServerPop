#! /bin/bash
# @edt ASIX Sergi Muñoz Carmona
# install.sh
#---------------------------------

#Creem els usuaris
useradd marta
useradd pere
echo "marta" | passwd --stdin marta
echo "pere" | passwd --stdin pere

#Creem correu
cp /opt/docker/marta /var/spool/mail/marta
cp /opt/docker/pere /var/spool/mail/pere

#Donem els permissos
chown -R marta.marta /var/spool/mail/marta
chown -R pere.pere /var/spool/mail/pere

#Copiem fitxers
cp /opt/docker/file.pdf /var/ftp/file.pdf
cp /opt/docker/file.txt /var/ftp/pub/file.txt
cp /opt/docker/xinetd.d/* /etc/xinetd.d/
/usr/bin/ssh-keygen -A



