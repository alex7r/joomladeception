#!/usr/bin/env bash

cd /var/www/composer
vendor/bin/codecept bootstrap --empty
vendor/bin/codecept generate:suite acceptance