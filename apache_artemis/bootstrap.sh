#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

# Paths
RH_HOME=/opt/rh
ARTEMIS_HOME=/opt/rh/apache-artemis-1.0.0

# Open firewall for web/openwire
sudo firewall-cmd --zone=public --add-port=8161/tcp --permanent
sudo firewall-cmd --zone=public --add-port=61616/tcp --permanent
sudo firewall-cmd --reload

# ulimits values needed by the processes inside the container
ulimit -u 4096
ulimit -n 4096

sudo mkdir -p $ARTEMIS_HOME
sudo mkdir broker -p $RH_HOME/broker

# Untar Artemis
sudo unzip /tmp/apache-artemis-1.0.0-bin.zip -d $RH_HOME

# Set ownership of Artemis
sudo chown -R vagrant:vagrant /opt/rh/

# Give write-access to bootstrap
sudo chmod +x /home/vagrant/bootstrap-artemis.sh
sh /home/vagrant/bootstrap-artemis.sh

# Set debug mode off
set +x
