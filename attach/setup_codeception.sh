#!/usr/bin/env bash

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
mkdir /var/www/composer
cd /var/www/composer
composer require codeception/codeception