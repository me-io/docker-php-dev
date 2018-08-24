# Dockerfile
ARG PHP_VERSION
ARG BOOT2DOCKER_ID
ARG BOOT2DOCKER_GID
ARG DEV_USER

# https://hub.docker.com/r/meio/php/
FROM meio/php:${PHP_VERSION}
MAINTAINER Mohamed Meabed <meabed@me.io>

ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

ENV BUILD_PACKAGES \
	curl \
	git \
	zip \
	unzip \
	vim \
	openssh-server \
	zsh \
	figlet \
	sysvbanner \
	htop \
	python-pip \
	wget \
	telnet \
	xvfb \
	libfontconfig \
	libxrender1 \
	libxext6 \
	libtidy5 \
	fontconfig \
	libxrender-dev \
	libx11-dev \
	libxext-dev \
	libfontconfig1-dev \
	libfreetype6-dev \
	zlib1g \
	libx11-6 \
	openssl \
	libc-client2007e \
    sudo \
    ncdu \
    inetutils-ping

RUN apt-get update &&\
    apt-get -qq install -y ${BUILD_PACKAGES} &&\
    composer self-update &&\
    pip install --upgrade bumpversion pip supervisor supervisor-stdout &&\
    apt-get purge --auto-remove -y ${BUILD_PACKAGES} ;\
    apt-get autoremove --purge -y ;\
    apt-get clean -y ;\
    rm -rf /var/lib/apt/* ;\
    rm -rf /var/lib/dpkg/info/* ;\
    rm -rf /var/lib/cache/* ;\
    rm -rf /var/lib/log/* ;\
    rm -rf /var/tmp/* ;\
    rm -rf /tmp/*

ADD ./etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
ADD ./etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
# Install zsh
ADD ./etc/install-zsh.sh /root/install-zsh.sh
ADD ./etc/install-zsh.sh /home/${DEV_USER}/install-zsh.sh

RUN chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub &&\
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config &&\
    echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    userdel ${DEV_USER} &&\
    mkdir -p /home/${DEV_USER} &&\
    useradd -d /home/${DEV_USER} ${DEV_USER} &&\
    passwd -d ${DEV_USER} &&\
    passwd -d root &&\
    adduser ${DEV_USER} sudo &&\
    chsh -s `which bash` ${DEV_USER} && chown ${DEV_USER}:${DEV_USER} /home/${DEV_USER} && chmod -R 777 /home/${DEV_USER} &&\
    chmod +x /root/install-zsh.sh &&\
    chmod +x /home/${DEV_USER}/install-zsh.sh &&\
    sh /root/install-zsh.sh &&\
    su - ${DEV_USER} -c "sh /home/${DEV_USER}/install-zsh.sh" &&\
    usermod -u ${BOOT2DOCKER_ID} ${DEV_USER} &&\
    usermod -G staff ${DEV_USER} &&\
    groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && groupmod -g ${BOOT2DOCKER_GID} staff &&\
    rm /root/.zshrc &&\
    chsh -s `which zsh` &&\
    chsh -s `which zsh` ${DEV_USER} &&\
    chmod -R 755 /usr/local/share/zsh*
