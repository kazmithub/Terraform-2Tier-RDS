#!/bin/bash
set -x
sleep 2m
apt-get update -y
apt-get install -y mysql-server php php-mysql
apt-get install -y apache2 
mysql -u admin -p0514457570  -h ${endpoint} <<MYSQL_SCRIPT
CREATE DATABASE test;
use test;
use test;
CREATE TABLE users (
id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
firstname VARCHAR(30) NOT NULL,
lastname VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL,
age INT(3),
location VARCHAR(50),
date TIMESTAMP
);
MYSQL_SCRIPT
apt-get install -y unzip
systemctl start apache2
systemctl enable apache2
cd /var/www
rm -rf html
wget https://s3.amazonaws.com/alamkey/html.zip
unzip html.zip
## Change the last line
sed -i -e 's/localhost/${endpoint}/g' /var/www/html/config.php