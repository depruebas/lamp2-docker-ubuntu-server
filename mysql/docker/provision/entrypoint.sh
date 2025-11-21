#!/bin/bash

# Copy skeleton files if they do not exist; 
# this only happens the first time the container is created.

echo "Copy skeleton files into user path"
if [ ! -f /home/ubuntu/.bashrc ]; then 
    cp /etc/skel/.bashrc /home/ubuntu/.bashrc 
fi

if [ ! -f /home/ubuntu/.profile ]; then 
    cp /etc/skel/.profile /home/ubuntu/.profile 
fi

if [ ! -f /home/ubuntu/.bash_logout ]; then 
    cp /etc/skel/.bash_logout /home/ubuntu/.bash_logout
fi

echo "Added specific settings to the user profile file"

echo 'export LS_OPTIONS="--color=auto"' >> /home/ubuntu/.bashrc 
echo 'eval "$(dircolors -b)"' >> /home/ubuntu/.bashrc
echo 'alias ls="ls --color=auto"' >> /home/ubuntu/.bashrc
echo 'alias ll="ls -alF"' >> /home/ubuntu/.bashrc 
echo 'alias la="ls -A"' >> /home/ubuntu/.bashrc
echo 'alias l="ls -CF"' >> /home/ubuntu/.bashrc 
echo 'PS1="\[\e[01;33m\]\u\[\e[00m\]@\[\e[01;35m\]\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ "' >> /home/ubuntu/.bashrc

##
# Section: Download, unzip and configure phpMyAdmin and initialize Apache2
##

echo "Started phpMyAdmin"

cd /tmp
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar -xzf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-*-all-languages /var/www/phpmyadmin
mkdir -p /var/www/phpmyadmin/tmp
cd /var/www/phpmyadmin
cp config.sample.inc.php config.inc.php

sed -i "s/\(\$cfg\['Servers'\]\[\$i\]\['host'\]\s*=\s*\)'localhost'/\1'127.0.0.1'/" config.inc.php

BLOWFISH_SECRET=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+=' < /dev/urandom | head -c 32)
# Escapar caracteres especiales para sed
ESCAPED_SECRET=$(printf '%s\n' "$BLOWFISH_SECRET" | sed 's/[&/\]/\\&/g')
sed -i "s|\(\$cfg\['blowfish_secret'\] = \)'';|\1'$ESCAPED_SECRET';|" config.inc.php


# # Establecer permisos
chown -R www-data:www-data /var/www/phpmyadmin
chmod -R 755 /var/www/phpmyadmin

# Configure and Init Apache2
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load 
ln -s /home/ubuntu/apache-vhost.conf  /etc/apache2/sites-enabled/apache-vhost.conf
rm /etc/apache2/sites-enabled/000-default.conf
sed -i '$aListen 8080' /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/apache2.conf

apache2ctl -D FOREGROUND &

##
# Section: Star and configure MySql
##

echo "Star and configure MySql"

sed -i '/^[[:space:]]*bind-address[[:space:]]*=[[:space:]]*127\.0\.0\.1/d' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '/^[[:space:]]*mysqlx-bind-address[[:space:]]*=[[:space:]]*127\.0\.0\.1/d' /etc/mysql/mysql.conf.d/mysqld.cnf


#chown -R mysql:mysql /var/lib/mysql

# Init MySQL
service mysql start

echo "Sleep 15 seconds to star MySql"
sleep 15

service mysql status

MYSQL_ROOT_PASSWORD=root
#

# # Create a new additional user if is needed
# MYSQL_USER=devuser
# MYSQL_USER_PASSWORD=root
# if [ ! -z "$MYSQL_USER" ] && [ ! -z "$MYSQL_USER_PASSWORD" ]; then
#     mysql -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_USER_PASSWORD}';"
#     mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';"
# fi

echo "Create and update root user"

mysql -e "CREATE USER 'root'@'%' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';"
mysql -u root -proot -e "FLUSH PRIVILEGES;"

echo "Go to home and run bash"
cd /home/ubuntu
exec /bin/bash