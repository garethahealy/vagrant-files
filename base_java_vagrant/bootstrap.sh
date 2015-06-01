#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

sudo yum clean all && \
     yum install -y epel-release && \
     yum -y update && \
     yum install -y java-1.7.0-openjdk.x86_64 java-1.7.0-openjdk-devel.x86_64 && \
     yum install -y wget vim zip unzip sshpass nmap lokkit

# Set debug mode off
set +x
