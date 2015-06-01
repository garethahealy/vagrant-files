#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

# Add apache-maven repo to yum
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

# Yum update current system and install pre-reqs
sudo yum clean all && \
     yum install -y epel-release && \
     yum -y update && \
     yum install -y java-1.7.0-openjdk.x86_64 java-1.7.0-openjdk-devel.x86_64 && \
     yum install -y wget vim zip unzip sshpass nmap lokkit apache-maven git libaio

# Set debug mode off
set +x
