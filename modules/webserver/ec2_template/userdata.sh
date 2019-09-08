#!/bin/bash
sudo su -
yum update -y
sudo amazon-linux-extras install epel
yum install httpd php php-mcrypt.x86_64 php-mysql php-xml php-xmlrpc php-soap mod_ssl php-gd logrotate mysql -y
aws s3 cp s3://xp-bucket-test/webserver_bucket/html.tar.gz /var/www/html
aws s3 cp s3://xp-bucket-test/webserver_bucket/joomla.sql /var/www/
#aws s3 cp s3://xp-bucket-test/webserver_bucket/Joomla_3.9.11-Stable-Full_Package.tar.gz /var/www/html
aws s3 cp s3://xp-bucket-test/webserver_bucket/selfsign_crt/ca.crt /etc/pki/tls/certs
aws s3 cp s3://xp-bucket-test/webserver_bucket/selfsign_crt/ca.key /etc/pki/tls/private
aws s3 cp s3://xp-bucket-test/webserver_bucket/selfsign_crt/ca.csr /etc/pki/tls/private
aws s3 cp s3://xp-bucket-test/webserver_bucket/selfsign_crt/ssl.conf /etc/httpd/conf.d
cd /var/www/html/
tar -xzvf html.tar.gz
mv html/* .
rm -rf html.tar.gz html
sed -i 's/_DATABASE_HOST_/'${db_endpoint}'/g' configuration.php
sed -i 's/_USER_/'${db_admin}'/g' configuration.php
sed -i 's/_PASSWORD_/'${db_passwd}'/g' configuration.php
sed -i 's/_EMAIL_/'${jml_mail}'/g' configuration.php
sed -i 's/_SITE_NAME_/'${site_name}'/g' configuration.php
sed -i 's/_DB_NAME_/'${db_name}'/g' configuration.php
cd /var/www/
mysql --user=${db_admin} --host=${db_endpoint} --password=${db_passwd}
drop database joomla;
create database joomla character set utf8 collate utf8_general_ci;
use joomla
source joomla.sql
chown -R apache:apache  /var/www/html/
systemctl restart httpd
systemctl enable httpd.service

