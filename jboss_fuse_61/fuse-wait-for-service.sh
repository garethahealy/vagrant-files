#!/usr/bin/env bash

shopt -s expand_aliases

# Set debug mode and halt on errors
set -x
set -e

# Full path of your ssh, used by the aliases
SSH_PATH=$(which ssh)

#ssh2fabric() {
#    sshpass -p admin $SSH_PATH -p 8101 -o ServerAliveCountMax=100 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@localhost "$@"
#}

# Function to connect to the ssh server exposed by JBoss Fuse. Uses sshpass to script the password authentication
alias ssh2fabric="sshpass -p admin $SSH_PATH -p 8101 -o ServerAliveCountMax=100 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@localhost"

# wait for ssh server to be up, avoids "Connection reset by peer" errors
while ! ssh2fabric "echo up" ; do sleep 1s; done;

# Wait for critical components to be available before progressing with other steps
ssh2fabric "wait-for-service -t 300000 io.fabric8.api.BootstrapComplete"

# Scaffold fuse
ssh2fabric "shell:source /home/vagrant/scaffold-fuse-fabric.karaf"

# Set debug mode off
set +x
