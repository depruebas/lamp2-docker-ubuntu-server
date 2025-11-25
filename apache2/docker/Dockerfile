# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install basic packages and Apache2, MySql, PHP and mods apache2
RUN apt-get update && apt-get install -y \
    apache2 php mysql-client postgresql-client \
    php-mysqli php-mbstring php-zip php-gd php-json php-curl libapache2-mod-php php-pgsql php-dom php-intl \
    curl \
    wget \
    tar \
    nano \
    vim \
    git \
    net-tools \
    iputils-ping \
    systemd \
    sudo \
    iproute2 locales \
    openssh-server \
    htop \
    tzdata \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set spanish language
RUN locale-gen es_ES.UTF-8
RUN echo 'echo "LANG=es_ES" > /etc/default/locale'
ENV LC_ALL=es_ES.UTF-8

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

# Create directories 
RUN mkdir -p /opt/start && mkdir /data

COPY ./provision/entrypoint.sh /opt/start/entrypoint.sh
RUN chmod +x /opt/start/entrypoint.sh 

# Crear el usuario ubuntu con contraseña 'ubuntu' y permisos sudo
RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd && \
    adduser ubuntu sudo

# Configurar el servidor SSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'AllowUsers ubuntu' >> /etc/ssh/sshd_config

WORKDIR /home/ubuntu

# Default command (optional)
ENTRYPOINT ["/opt/start/entrypoint.sh"]
