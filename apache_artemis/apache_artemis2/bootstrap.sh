#!/usr/bin/env bash

set -x

# ulimits values need to be higher for this process
ulimit -u 4096
ulimit -n 4096

# Unzip Apache Artemis
cd /opt/rh &&
    unzip activemq-artemis-2.0.0-bin.zip

# Open firewall for web/openwire
sudo firewall-cmd --zone=public --add-port=8161/tcp --permanent     #web
sudo firewall-cmd --zone=public --add-port=61616/tcp --permanent    #openwire
sudo firewall-cmd --zone=public --add-port=61613/tcp --permanent    #stomp
sudo firewall-cmd --zone=public --add-port=5672/tcp --permanent     #amqp
sudo firewall-cmd --zone=public --add-port=1883/tcp --permanent     #mqtt
sudo firewall-cmd --reload


