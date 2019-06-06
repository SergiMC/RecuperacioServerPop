#! /bin/bash
#@edt ASIX Sergi Muñoz Carmona
# startup.sh
#---------------------------------------
/opt/docker/install.sh && echo "Ok install"
/usr/sbin/xinetd -dontfork && echo "xinetd OK"
/usr/sbin/httpd
/usr/sbin/vsftpd
/usr/sbin/sshd
/usr/sbin/in.tftpd -s /var/lib/tftpboot


