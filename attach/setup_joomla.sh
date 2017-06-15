#!/usr/bin/env bash

JUSERID=$[ ( $RANDOM % 100 )  + 1 ]
JUSERNAME=${4:-"admin"}
JUSEREMAIL="${JUSERNAME}@localhost.com"
JUSERPASS=${3:-"qweasd"}
DB=${5:-"joomla_db"}
DBUSER=${6:-"jdbuser"}
DBPASS=${7:-"dbupass"}
DBPREFIX=${2:-"prfx_"}
JOOMLAVERSION=${1:-"3.7.1"}

rm -f /var/www/html/index.html
apt-get install -y unzip wget
wget https://github.com/joomla/joomla-cms/releases/download/$JOOMLAVERSION/Joomla_$JOOMLAVERSION-Stable-Full_Package.zip -P /var/tmp/
unzip /var/tmp/Joomla_$JOOMLAVERSION-Stable-Full_Package.zip -d /var/www/html/
cd /var/www/html/
chown -R www-data:www-data .
sed -i "s/\$user = ''/\$user = '${DBUSER}'/" installation/configuration.php-dist
sed -i "s/\$password = ''/\$password = '${DBPASS}'/" installation/configuration.php-dist
sed -i "s/\$db = ''/\$db = '${DB}'/" installation/configuration.php-dist
sed -i "s/\$dbprefix = 'jos_'/\$dbprefix = '${DBPREFIX}'/" installation/configuration.php-dist
sed -i "s/\$tmp_path = '\/tmp'/\$tmp_path = '\/var\/www\/tmp'/" installation/configuration.php-dist
sed -i "s/\$log_path = '\/var\/logs'/\$log_path = '\/var\/www\/logs'/" installation/configuration.php-dist
sed -i "s/\$cache_handler = 'file'/\$cache_handler = ''/" installation/configuration.php-dist
sed -i "s/\$mailfrom    = ''/\$mailfrom = '${JUSEREMAIL}'/" installation/configuration.php-dist
sed -i "s/\$replyto     = ''/\$replyto = '${JUSEREMAIL}'/" installation/configuration.php-dist
mv installation/configuration.php-dist configuration.php
service mysql restart
echo "CREATE DATABASE ${DB}" | mysql -u root --password=qweasd
echo "CREATE USER '${DBUSER}'@'%' IDENTIFIED BY '${DBPASS}';" | mysql -u root --password=qweasd
echo "GRANT ALL ON ${DB}.* TO '${DBUSER}'@'%';" | mysql -u root --password=qweasd
sed -i "s/#__/${DBPREFIX}/" installation/sql/mysql/joomla.sql
cat installation/sql/mysql/joomla.sql | mysql -u $DBUSER --password=$DBPASS $DB
## create joomla user
JPASS="$(echo -n "$JUSERPASS" | md5sum | awk '{ print $1 }' )"
echo "INSERT INTO \`${DBPREFIX}users\` (\`id\`, \`name\`, \`username\`, \`email\`, \`password\`, \`block\`, \`sendEmail\`, \`registerDate\`, \`lastvisitDate\`, \`activation\`, \`params\`, \`lastResetTime\`, \`resetCount\`, \`otpKey\`, \`otep\`, \`requireReset\`) VALUES ('${JUSERID}', 'Me', '${JUSERNAME}', '${JUSEREMAIL}', '${JPASS}', '0', '0', '1993-09-24 17:05:00', NOW(), '', '', NOW(), '0', '', '', '0');"
echo "INSERT INTO \`${DBPREFIX}users\` (\`id\`, \`name\`, \`username\`, \`email\`, \`password\`, \`block\`, \`sendEmail\`, \`registerDate\`, \`lastvisitDate\`, \`activation\`, \`params\`, \`lastResetTime\`, \`resetCount\`, \`otpKey\`, \`otep\`, \`requireReset\`) VALUES ('${JUSERID}', 'Me', '${JUSERNAME}', '${JUSEREMAIL}', '${JPASS}', '0', '0', '1993-09-24 17:05:00', NOW(), '', '', NOW(), '0', '', '', '0');" | mysql -u $DBUSER --password=$DBPASS $DB
echo "INSERT INTO \`${DBPREFIX}user_usergroup_map\` (\`user_id\`, \`group_id\`) VALUES ('${JUSERID}', '8');" | mysql -u $DBUSER --password=$DBPASS $DB
JUSERINC=$((JUSERID+1))
echo "ALTER TABLE \`${DBPREFIX}users\` auto_increment = ${JUSERINC};" | mysql -u $DBUSER --password=$DBPASS $DB

rm -rf installation/
cd ../
mkdir logs
mkdir tmp
chown www-data:www-data logs
chown www-data:www-data tmp