FROM ubuntu:14.04

EXPOSE 80

RUN apt-get update
RUN apt-get -y install software-properties-common -q
RUN apt-get -y install python-software-properties -q
RUN apt-add-repository -y ppa:ondrej/apache2
RUN apt-add-repository -y ppa:ondrej/php
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update
RUN apt-get install -y apache2 git curl zip wget
RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password password qweasd'"
RUN /bin/bash -c "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password qweasd'"
RUN apt-get -y install mysql-server
RUN apt-get install php7.0 php7.0-fpm php7.0-mysql php7.0-xml libapache2-mod-php7.0 php7.0-curl php7.0-sqlite php7.0-mcrypt php7.0-gd php7.0-mbstring php7.0-xmlrpc -y
RUN /bin/bash -c "debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'"
RUN /bin/bash -c "debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password qweasd'"
RUN /bin/bash -c "debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password qweasd'"
RUN /bin/bash -c "debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password qweasd'"
RUN /bin/bash -c "debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect none'"
RUN apt-get -y install phpmyadmin > /dev/null 2>&1
RUN a2dismod php5
RUN a2enmod authn_core
RUN a2enmod proxy_fcgi setenvif
RUN a2enmod rewrite
RUN phpenmod mcrypt
RUN phpenmod mbstring
RUN a2enconf php7.0-fpm
RUN a2enconf phpmyadmin
RUN service apache2 stop
RUN php -r '$cont = file_get_contents("/etc/apache2/apache2.conf"); file_put_contents("/etc/apache2/apache2.conf", preg_replace("/(<Directory \/var\/www\/>(.|\n)*AllowOverride )None/m","$1All",$cont));'
RUN ifconfig
RUN update-rc.d apache2 defaults

# composer intall block
RUN mkdir /var/www/composer/
RUN cd /var/www/composer/ ; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" ; \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" ; \
    php composer-setup.php ; \
    php -r "unlink('composer-setup.php');" ;

# install codeception
RUN cd /var/www/composer/ ; \
    php composer.phar require codeception/codeception --dev ; \
    php composer.phar global require squizlabs/php_codesniffer --dev ; \
    apt-get install -y build-essential chrpath libssl-dev libxft-dev ; \
    apt-get install -y libfreetype6 libfreetype6-dev ; \
    apt-get install -y libfontconfig1 libfontconfig1-dev ;

ENV PHANTOM_JS "phantomjs-2.1.1-linux-x86_64"
# intstall phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
RUN mv $PHANTOM_JS.tar.bz2 /usr/local/share/
RUN cd /usr/local/share/ ; \
    tar xvjf $PHANTOM_JS.tar.bz2 ; \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs ; \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs ; \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs ; \
    rm -fr $PHANTOM_JS.tar.bz2 ;
RUN cd /etc/init.d ; \
    wget https://raw.githubusercontent.com/alex7r/joomla-ssh-installation-vagrant/master/phantomjs ; \
    chmod +x phantomjs ;
RUN echo "WEBDRIVER_PORT=8190" > /etc/default/phantomjs
RUN update-rc.d phantomjs defaults
RUN cd /var/www/composer/ ; \
    php composer.phar require jonnyw/php-phantomjs:2.* --dev ; \
    vendor/bin/codecept bootstrap --empty ; \
    vendor/bin/codecept generate:suite acceptance ;


CMD /usr/sbin/apache2ctl -D FOREGROUND && service phantomjs start && service --status-all
