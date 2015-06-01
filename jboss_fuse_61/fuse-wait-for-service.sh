#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

ps -deaf | grep karaf

# Full path of your ssh, used by the aliases
SSH_PATH=$(which ssh)

# Function to connect to the ssh server exposed by JBoss Fuse. Uses sshpass to script the password authentication
ssh2fabric() {
    sshpass -p admin $SSH_PATH -p 8101 -o ServerAliveCountMax=100 -o ConnectionAttempts=180 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o LogLevel=ERROR admin@localhost "$@"
}

# Wait for critical components to be available before progressing with other steps
ssh2fabric "wait-for-service -t 300000 io.fabric8.api.BootstrapComplete"

# Set debug mode off
set +x



