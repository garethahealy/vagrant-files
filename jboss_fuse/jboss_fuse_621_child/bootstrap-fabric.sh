#!/usr/bin/env bash

set -x

# Run scaffolding scripts to provision containers
cd /tmp &&
    unzip scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 install-fuse.sh &&
    ./install-fuse-and-deploy.sh -e vagrant-child -u vagrant
