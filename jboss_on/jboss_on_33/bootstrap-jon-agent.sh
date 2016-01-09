#!/usr/bin/env bash

set -x

# Run scaffolding scripts to install JBoss Fuse
cd /tmp &&
    unzip scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh &&
    ./install-fuse-and-deploy.sh -e vagrant-child -u vagrant

##todo - get agent and install
cd /opt/rh &&
    wget -O jon-agent-4.12.0.JON330GA.jar http://jonserver.jbosson33.vagrant.local:7080/agentupdate/download
   # && java -jar jon-agent-4.12.0.JON330GA.jar --install

