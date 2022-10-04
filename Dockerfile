FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y gnupg

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

# Update system
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get upgrade -y

# Install essentials
RUN apt-get install -y git flex-old bison build-essential wget vim libc6:i386 csh

# Install coolc compiler
WORKDIR /usr/class/cs143/cool
COPY --chown=root:root . .
RUN echo "export PATH=$PATH:/usr/class/cs143/cool/bin" >> /root/.bashrc

# Cleanup
RUN apt-get autoremove && apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/cs143

ENTRYPOINT ["/bin/bash"]
