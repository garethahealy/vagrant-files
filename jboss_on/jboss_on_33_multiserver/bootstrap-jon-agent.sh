#!/usr/bin/env bash

set -x

# Run scaffolding scripts to install JBoss Fuse
cd /tmp &&
    unzip -o scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh
