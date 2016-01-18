#!/usr/bin/env bash

set -x

# ulimits values need to be higher for this process
ulimit -u 4096
ulimit -n 4096

# Should be in base box
sudo chown -R vagrant:vagrant /home/vagrant/.m2

# Open firewall for Fuse - https://access.redhat.com/solutions/1256553
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

