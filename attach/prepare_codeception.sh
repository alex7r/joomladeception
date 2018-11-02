#!/usr/bin/env bash

cd /var/www/composer
ln -s /var/www/composer/vendor/bin/codecept /usr/bin/codecept
codecept bootstrap --empty
codecept generate:suite acceptance
cat /docker-attach/webdriver.yml >> /var/www/composer/tests/acceptance.suite.yml
cp /docker-attach/fly_test.sh /var/www/composer/
chmod +x /var/www/composer/fly_test.sh
ln -s /var/www/composer/fly_test.sh /usr/bin/acceptence_test