#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

# Open firewall for hawtio
sudo firewall-cmd --zone=public --add-port=8181/tcp --permanent
sudo firewall-cmd --reload

# Give write-access to bootstrap
sudo chmod +x /home/vagrant/bootstrap-fuse.sh

RH_HOME=/opt/rh
FUSE_HOME=/opt/rh/jboss-fuse-61

# ulimits values needed by the processes inside the container
ulimit -u 4096
ulimit -n 4096

sudo mkdir -p $FUSE_HOME

# Untar Fuse
sudo tar xjf /tmp/jboss-fuse-61.tbz2 --directory $RH_HOME

# Set ownership of Fuse
sudo chown -R vagrant:vagrant /opt/rh/

# Start fuse on root node
"$FUSE_HOME/bin/start"

# Set debug mode off
set +x
