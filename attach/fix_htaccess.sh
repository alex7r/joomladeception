#!/usr/bin/env bash

cd /var/www/html
php -r '$cont = file_get_contents("/etc/apache2/sites-available/000-default.conf"); file_put_contents("/etc/apache2/sites-available/000-default.conf", preg_replace("/(\\/var\\/www\\/html)/", "$1\n\t<Directory \"$1\">\n\t\tAllowOverride All\n\t</Directory>",$cont));'
sed -i "s/## End - Joomla! core SEF Section./## End - Joomla! core SEF Section.\nphp_value upload_max_filesize 8M/" htaccess.txt
mv htaccess.txt .htaccess
