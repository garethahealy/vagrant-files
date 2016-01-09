#!/usr/bin/env bash

set -x

# ulimits values need to be higher for this process
ulimit -u 4096
ulimit -n 4096

# Open firewall for JON - https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Operations_Network/3.3/pdf/Installation_Guide/Red_Hat_JBoss_Operations_Network-3.3-Installation_Guide-en-US.pdf
## Table 3.2. Default JBoss ON Ports
sudo firewall-cmd --zone=public --add-port=7080/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=16163/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9142/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7299/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7100/tcp --permanent

sudo firewall-cmd --zone=public --add-port=5432/tcp --permanent
sudo firewall-cmd --reload





