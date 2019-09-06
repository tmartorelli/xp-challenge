#!/bin/bash
sudo su -
yum update -y
sudo amazon-linux-extras install epel
yum install httpd php php-mcrypt.x86_64 php-mysql php-xml php-xmlrpc php-soap php-gd logrotate -y
aws s3 cp s3://cms-kata-claranet-tm/html.tgz /var/www/html
aws s3 cp s3://cms-kata-claranet-tm/ca.crt /etc/pki/tls/certs
aws s3 cp s3://cms-kata-claranet-tm/ca.key /etc/pki/tls/private
aws s3 cp s3://cms-kata-claranet-tm/ca.csr /etc/pki/tls/private
aws s3 cp s3://cms-kata-claranet-tm/ssl.conf /etc/httpd/conf.d
cd /var/www/html/
tar -xzvf html.tgz
mv html/* .
rm -rf html/ 
chown -R apache:apache  /var/www/html/
systemctl restart httpd
systemctl enable httpd.service