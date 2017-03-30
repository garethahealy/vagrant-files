#!/usr/bin/env bash

set -x

# Run scaffolding scripts to provision containers
cd /tmp &&
    unzip -o scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 ./*.sh &&
    ./install-fuse-and-deploy.sh -e vagrant-child -u vagrant
