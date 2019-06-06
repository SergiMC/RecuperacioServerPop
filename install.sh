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
cp /opt/docker/correu_marta /var/spool/mail/correu_marta
cp /opt/docker/missatge_pere /var/spool/mail/correu_pere

#Donem els permissos
chown -R marta.marta /var/spool/mail/correu_marta
chown -R pere.pere /var/spool/mail/correu_pere

#Copiem fitxers
cp /opt/docker/file.pdf /var/ftp/file.pdf
cp /opt/docker/file.txt /var/pub/file.txt
cp /opt/docker/xinetd.d/* /etc/xinetd.d/




