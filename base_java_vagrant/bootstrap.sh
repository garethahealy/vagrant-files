#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

sudo yum clean all && \
     yum install -y epel-release && \
     yum -y update && \
     yum install -y java-1.7.0-openjdk.x86_64 wget vim zip unzip sshpass

# Set debug mode off
set +x
