#!/usr/bin/env bash

cd /var/www/composer
ln -s /var/www/composer/vendor/bin/codecept /usr/bin/codecept
codecept bootstrap --empty
codecept generate:suite acceptance
cat /docker-attach/webdriver.yml >> /var/www/composer/tests/acceptance.suite.yml