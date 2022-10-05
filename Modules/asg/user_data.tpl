#!/bin/bash
yum update -y
yum install -y amazon-efs-utils wget httpd php mysql php-mysql
case $(ps -p 1 -o comm | tail -1) in
systemd) systemctl enable --now httpd ;;
init) chkconfig httpd on; service httpd start ;;
*) echo "Error starting httpd (OS not using init or systemd)." 2>&1
esac
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs-dns}:/  /var/www/html
if [ ! -f /var/www/html/bootcamp-app.tar.gz ]; then
cd /var/www/html
wget https://s3.amazonaws.com/immersionday-labs/bootcamp-app.tar
tar xvf bootcamp-app.tar
chown apache:root /var/www/html/rds.conf.php
fi