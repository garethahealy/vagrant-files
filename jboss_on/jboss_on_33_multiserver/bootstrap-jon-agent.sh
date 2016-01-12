#!/usr/bin/env bash

set -x
exit 0

# Run scaffolding scripts to install JBoss Fuse
cd /tmp &&
    unzip -o scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh &&
    ./install-fuse.sh -e vagrant-child

cd /opt/rh/scripts/commands &&
    ./start-fuse.sh "vagrant-child"
