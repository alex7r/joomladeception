#!/usr/bin/env bash

debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect none'
# MYSQL 5.7 + PHPMYADMIN BUG FIX START
apt-get install dbconfig-common
echo -e "dbc_install='true'\n \
dbc_upgrade='true'\n \
dbc_remove='true'\n \
dbc_dbtype='mysql'\n \
dbc_dbuser='phpmyadmin'\n \
dbc_dbpass='qwerty'\n \
dbc_dballow=''\n \
dbc_dbserver='localhost'\n \
dbc_dbport='0'\n \
dbc_dbname='phpmyadmin'\n \
dbc_dbadmin='debian-sys-maint'\n \
dbc_basepath=''\n \
dbc_ssl=''\n \
dbc_authmethod_admin=''\n \
dbc_authmethod_user=''" >> /etc/dbconfig-common/phpmyadmin.conf
# MYSQL 5.7 + PHPMYADMIN BUG FIX END
apt-get -y install phpmyadmin
cp -l /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin