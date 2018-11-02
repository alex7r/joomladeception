#!/usr/bin/env bash

debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect none'
apt-get -y install phpmyadmin
# cp -l /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin