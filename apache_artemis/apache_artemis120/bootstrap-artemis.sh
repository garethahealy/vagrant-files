#!/usr/bin/env bash

set -x

# Create a broker and start it up
cd /opt/rh &&
    rm -rf broker &&
    apache-artemis-1.2.0/bin/artemis create --allow-anonymous --user admin --password admin broker &&
    sed -i "s/localhost:8161/0.0.0.0:8161/" /opt/rh/broker/etc/bootstrap.xml &&
    broker/bin/artemis-service start
