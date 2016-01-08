#!/usr/bin/env bash

set -x

# Run scaffolding scripts to install JBoss Fuse
cd /tmp &&
    unzip scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh &&
    ./install-fuse-and-deploy.sh -e vagrant-child -u vagrant

##todo - get agent and install
