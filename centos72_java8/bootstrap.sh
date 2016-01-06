#!/usr/bin/env bash

set -x

# Add apache-maven repo to yum
sudo wget -O /etc/yum.repos.d/epel-apache-maven.repo http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo

# Yum update current system and install pre-reqs
# The below 'yum install' are split into:
# - System
# - Java
# - Fuse
# - Other Middleware
# - Other Tools
sudo yum makecache && \
     yum install -y deltarpm && \
     yum install -y epel-release && \
     yum update -y && \
     yum install -y gcc kernel-devel make
     yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 && \
     yum install -y curl wget vim zip unzip tar telnet bc git && \
     yum install -y lokkit sshpass nmap apache-maven libaio && \
     yum clean all

sudo mkdir -p /opt/rh && \
    chown -R vagrant:vagrant /opt/rh && \
    chown -R vagrant:vagrant /home/vagrant/.m2

ulimit -u 4096
ulimit -n 4096

# Enable firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Open port for Java remote debugging
sudo firewall-cmd --zone=public --add-port=5005/tcp --permanent
sudo firewall-cmd --reload
