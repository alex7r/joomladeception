#!/usr/bin/env bash

apt-get update
debconf-set-selections <<< 'mysql-server mysql-server/root_password password qweasd'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password qweasd'
apt-get install -y apache2 git mysql-server
apt-get install sendmail -y
sed -i "s/127\.0\.0\.1.*xenial64//" /etc/hosts
sendmailconfig
apt-get install -y php php-fpm php-mysql php-xml libapache2-mod-php php-curl php7.0-sqlite php7.0-mcrypt php-gd php7.0-mbstring php-xmlrpc
#apt-get install php7.1-xdebug -y
a2enmod authn_core proxy_fcgi setenvif rewrite
a2enconf php7.0-fpm
phpenmod mcrypt mbstring