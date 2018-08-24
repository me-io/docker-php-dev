# Dockerfile
ARG PHP_VERSION

# https://hub.docker.com/r/meio/php/
FROM meio/php:${PHP_VERSION}
MAINTAINER Mohamed Meabed <meabed@me.io>

ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y \
	curl                    \
	git                     \
	zip                     \
	unzip                   \
	vim                     \
	openssh-server          \
	zsh                     \
	figlet                  \
	sysvbanner              \
	htop                    \
	python-pip              \
	wget                    \
	telnet                  \
	xvfb                    \
	libfontconfig           \
	libxrender1             \
	libxext6                \
	libtidy5                \
	fontconfig              \
	libxrender-dev          \
	libx11-dev              \
	libxext-dev             \
	libfontconfig1-dev      \
	libfreetype6-dev        \
	zlib1g                  \
	libx11-6                \
	openssl                 \
	libc-client2007e        \
    sudo                    \
    inetutils-ping

RUN apt-get remove libssl-dev -y && apt autoremove -y && apt-get autoclean -y

ADD ./etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
ADD ./etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub

RUN chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && echo "www-data ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN userdel www-data && mkdir -p /home/www-data && useradd -d /home/www-data www-data && passwd -d www-data && passwd -d root && adduser www-data sudo
RUN chsh -s `which bash` www-data && chown www-data:www-data /home/www-data && chmod -R 777 /home/www-data

# Install zsh
ADD ./etc/install-zsh.sh /root/install-zsh.sh
ADD ./etc/install-zsh.sh /home/www-data/install-zsh.sh

RUN chmod +x /root/install-zsh.sh
RUN chmod +x /home/www-data/install-zsh.sh
RUN sh /root/install-zsh.sh

RUN su - www-data -c "sh /home/www-data/install-zsh.sh"

ARG BOOT2DOCKER_ID
ARG BOOT2DOCKER_GID
# Tweaks to give write permissions to the app
RUN usermod -u ${BOOT2DOCKER_ID} www-data && \
    usermod -G staff www-data

RUN groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && groupmod -g ${BOOT2DOCKER_GID} staff

RUN rm /root/.zshrc && chsh -s `which zsh` && chsh -s `which zsh` www-data && chmod -R 755 /usr/local/share/zsh*

RUN composer self-update

RUN pip install --upgrade bumpversion pip supervisor supervisor-stdout

# Clean-up
RUN apt-get autoclean -y ;\
    apt-get clean ;\
    apt-get autoremove --purge -y ;\

RUN rm -rf /var/lib/apt/* ; \
    rm -rf /var/lib/cache/* ; \
    rm -rf /var/lib/log/* ; \
    rm -rf /var/tmp/* ; \
    rm -rf /tmp/*
