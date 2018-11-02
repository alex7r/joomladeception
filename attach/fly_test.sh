#!/usr/bin/env bash

cd /var/www/composer

codecept build
codecept generate:scenarios acceptance
codecept run acceptance --steps