#!/usr/bin/env bash

set -x

# Generate SSH key
ssh-keygen -f ~/.ssh/id_rsa -N '' -b 4048 -t rsa -C "VagrantFabric"

echo "StrictHostKeyChecking no
UserKnownHostsFile=/dev/null" >> ~/.ssh/config
chmod 600 ~/.ssh/config

sshpass -p vagrant ssh-copy-id vagrant@machine1.jbossfuse621.vagrant.local
sshpass -p vagrant ssh-copy-id vagrant@machine2.jbossfuse621.vagrant.local
sshpass -p vagrant ssh-copy-id vagrant@machine3.jbossfuse621.vagrant.local

# Run scaffolding scripts to provision containers
cd /tmp &&
    unzip scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 *.sh &&
    ./install-fuse-and-deploy.sh -e vagrant-ssh -u vagrant
