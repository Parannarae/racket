#Start from the Ubuntu 16.04 image
FROM ubuntu:16.04

# The image label
LABEL version="1"
LABEL description="A docker image for racket"
LABEL maintainer="seokhwan@peoplefund.co.kr"

# To remove debconf build warnings
ARG DEBIAN_FRONTEND=noninteractive

# Change the timezone
RUN mv /etc/localtime /etc/localtime.old \
    && ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Install required packages
RUN apt-get update && apt-get install --no-install-suggests -y \
    sudo \
    software-properties-common \
    libedit-dev \
    locales

# Get racket resource
RUN add-apt-repository ppa:plt/racket
RUN apt-get update && apt-get install --no-install-suggests -y \
    racket

# Change locale
# Install required default locale
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && echo 'ko_KR.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen
# Set default locale for the environment
ENV LC_ALL en_US.UTF-8
ENV LANG ko_KR.UTF-8

# Clean up the apt cache and temporary files
RUN rm -rf /temp \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Add non root user
RUN adduser --disabled-password --gecos '' ubuntu
# Allows user to sudo
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

WORKDIR /home/ubuntu

USER ubuntu