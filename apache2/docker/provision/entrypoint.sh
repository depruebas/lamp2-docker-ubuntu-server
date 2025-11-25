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

# echo "Added specific settings to the user profile file"

# echo "function parse_git_branch () {
#   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }
# "

# echo 'export LS_OPTIONS="--color=auto"' >> /home/ubuntu/.bashrc 
# echo 'eval "$(dircolors -b)"' >> /home/ubuntu/.bashrc
# echo 'alias ls="ls --color=auto"' >> /home/ubuntu/.bashrc
# echo 'alias ll="ls -alF"' >> /home/ubuntu/.bashrc 
# echo 'alias la="ls -A"' >> /home/ubuntu/.bashrc
# echo 'alias l="ls -CF"' >> /home/ubuntu/.bashrc 
# echo 'PS1="\[\e[01;33m\]\u\[\e[00m\]@\[\e[01;35m\]\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$(parse_git_branch)\$ "' >> /home/ubuntu/.bashrc

# Enable and configure Apache2
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load 
ln -s /home/ubuntu/2025.conf  /etc/apache2/sites-enabled/2025.conf
rm /etc/apache2/sites-enabled/000-default.conf
sed -i '$aListen 8080' /etc/apache2/ports.conf
echo "ServerName localhost" >> /etc/apache2/apache2.conf

sudo a2enmod unique_id
sudo a2enmod headers

apache2ctl -D FOREGROUND &

# Enable sshd deamon
service ssh start

echo "Go to home and run bash"
cd /home/ubuntu
exec /bin/bash