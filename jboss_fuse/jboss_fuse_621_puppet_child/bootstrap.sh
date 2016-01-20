#!/usr/bin/env bash

set -x

# Install/update basics
sudo yum makecache && \
     yum install -y deltarpm && \
     yum install -y epel-release && \
     yum update -y && \
     yum install -y gcc kernel-devel make && \
     yum clean all

# Enable firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Open ports
sudo firewall-cmd --zone=public --add-port=5005/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8181/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=3888/tcp --permanent

sudo firewall-cmd --zone=public --add-port=8101-8121/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2181-2201/tcp --permanent
sudo firewall-cmd --zone=public --add-port=1099-1129/tcp --permanent
sudo firewall-cmd --zone=public --add-port=44444-44464/tcp --permanent

sudo firewall-cmd --zone=public --add-port=9000-9010/tcp --permanent
sudo firewall-cmd --reload

# Run puppet
sudo /opt/puppetlabs/bin/puppet apply /opt/garethahealy/puppet/modules/jbossfuse621/manifests/init.pp
