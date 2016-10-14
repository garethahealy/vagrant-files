#!/usr/bin/env bash

set -x

# Run scaffolding scripts to provision containers
cd /tmp &&
    unzip -o scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh &&
    find . -type f -exec dos2unix {} {} \; &&
    ./install-fuse-and-deploy.sh -e vagrant-child -u vagrant
