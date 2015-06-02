#!/usr/bin/env bash

# Set debug mode and halt on errors
set -x
set -e

# Paths
RH_HOME=/opt/rh
ARTEMIS_HOME=/opt/rh/apache-artemis-1.0.0

# Remove broker already created
rm -rf $RH_HOME/broker

# Create a broker
cd $RH_HOME
$ARTEMIS_HOME/bin/artemis create --allow-anonymous --user admin --password admin broker

# Start Artemis
cd $RH_HOME/broker/bin
./artemis-service start
