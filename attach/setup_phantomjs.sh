#!/usr/bin/env bash

PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
apt-get install -y build-essential chrpath libssl-dev libxft-dev
apt-get install -y libfreetype6 libfreetype6-dev
apt-get install -y libfontconfig1 libfontconfig1-dev
cd ~
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
mv $PHANTOM_JS.tar.bz2 /usr/local/share/
cd /usr/local/share/
tar xvjf $PHANTOM_JS.tar.bz2
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs
rm -fr $PHANTOM_JS.tar.bz2
tr -d '\r' < /docker-attach/phantomjs > /etc/init.d/phantomjs
chmod +x /etc/init.d/phantomjs
cat << EOF > /etc/default/phantomjs
WEBDRIVER_PORT=8190
EOF
update-rc.d phantomjs defaults
service phantomjs start
cd /var/www/composer/
composer require jonnyw/php-phantomjs:2.*