# Dockerfile for Dummyapp
FROM php:7.1-apache

MAINTAINER José Gomes <jose.gomes@olx.com>

# Create folder to hold projects
RUN mkdir /var/www/dummyapp

# Create the volume
VOLUME /var/www/dummyapp

# Install dependency packages
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	libxml2-dev \
	libmemcached-dev

#ARG DOCKER_GID=993

RUN groupadd -g ${DOCKER_GID} docker \
  && curl -sSL https://get.docker.com/ | sh \
  && apt-get -q autoremove \
  && apt-get -q clean -y \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin 

RUN useradd -m -d /home/jenkins -s /bin/sh jenkins \
  && usermod -aG docker jenkins


CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
