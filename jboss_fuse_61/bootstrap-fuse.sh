#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

FUSE_HOME=/opt/rh/jboss-fuse-61

ps -deaf | grep karaf

# Full path of your ssh, used by the aliases
SSH_PATH=$(which ssh)

# Function to connect to the ssh server exposed by JBoss Fuse. Uses sshpass to script the password authentication
ssh2fabric() {
    sshpass -p admin $SSH_PATH -p 8101 -o ServerAliveCountMax=100 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@localhost "$@"
}

# Wait for critical components to be available before progressing with other steps
ssh2fabric "wait-for-service -t 300000 io.fabric8.api.BootstrapComplete"

# Create a new fabric
ssh2fabric "fabric:create --clean --resolver localip --global-resolver localip --wait-for-provisioning --profile fabric"

# Configure local maven
ssh2fabric "fabric:profile-edit --append --pid io.fabric8.agent/org.ops4j.pax.url.mvn.repositories=\"file:/vagrant/m2/repository@snapshots@id=maven-snapshots\" default"

# Add in the zookeeper commands to fabric, helps if we have issues in the future
ssh2fabric "fabric:profile-edit --features fabric-zookeeper-commands fabric"

# Create a new fabric version for the pacthes
ssh2fabric "fabric:version-create 1.1"
ssh2fabric "fabric:patch-apply --username admin --password admin --version 1.1 file:$FUSE_HOME/patch-zips/rollup2.zip"
ssh2fabric "fabric:patch-apply --username admin --password admin --version 1.1 file:$FUSE_HOME/patch-zips/rollup2-p3.zip"

# Upgrade the container so the patches take effect
ssh2fabric "fabric:container-upgrade 1.1 root"

# Set debug mode off
set +x

fabric:create --clean --wait-for-provisioning --resolver manualip --manual-ip jbossfuse61 --profile fabric

fabric:create --clean --wait-for-provisioning --profile fabric

fabric:profile-edit --features fabric-zookeeper-commands fabric
fabric:version-create 1.1

fabric:patch-apply --username admin --password admin --version 1.1 file:/opt/rh/jboss-fuse-61/patch-zips/rollup2.zip
fabric:patch-apply --username admin --password admin --version 1.1 file:/opt/rh/jboss-fuse-61/patch-zips/rollup2-p3.zip

fabric:container-upgrade 1.1 root
fabric:version-set-default 1.1
