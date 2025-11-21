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

# Configure PostgreSQL
VERSION=$(sudo -u postgres pg_config --version |  awk '{print $2}' | cut -d '.' -f 1)

# Activamos en postgresql.conf que postgreSQL escuche desde todas las IPs
echo -e "listen_addresses = '*'" | sudo tee -a /etc/postgresql/$VERSION/main/postgresql.conf

# Añadimos el usuario postgres al sistema
echo -e "local   all       postgres         md5" | sudo tee -a /etc/postgresql/$VERSION/main/pg_hba.conf

# Añadimos el rango de IPs desde donde accedemos al servidor, en este caso desde todas
echo -e "host all all 0.0.0.0 0.0.0.0 md5" | sudo tee -a /etc/postgresql/$VERSION/main/pg_hba.conf

service postgresql start

# Cambiamos la contraseña al usuario postgres, pero ojo, al del servidor de base de datos, 
# el usuario postgres del sistema no lo he tocado
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'root';"

# Reiniciamos servicio de psotgreSQL
service postgresql restart

cd /tmp
wget https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php
mkdir -p /var/www/adminer
mv /tmp/adminer-5.4.1.php /var/www/adminer/index.php

chown -R www-data:www-data /var/www/adminer
chmod -R 755 /var/www/adminer

# Configure and Init Apache2
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load 
ln -s /home/ubuntu/apache-vhost.conf  /etc/apache2/sites-enabled/apache-vhost.conf
rm /etc/apache2/sites-enabled/000-default.conf
sed -i '$aListen 8080' /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/apache2.conf

apache2ctl -D FOREGROUND &

# Enable sshd deamon
service ssh start

echo "Go to home and run bash"
cd /home/ubuntu
exec /bin/bash