#!/usr/bin/env bash

set -x

# Config JON DB settings
sudo sed -i "s/rhq.server.database.server-name=127.0.0.1/rhq.server.database.server-name=postgresmutli1.jbosson33.vagrant.local/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/rhq.server.database.connection-url=jdbc:postgresql:\/\/127.0.0.1:5432\/rhq/rhq.server.database.connection-url=jdbc:postgresql:\/\/postgresmutli1.jbosson33.vagrant.local:5432\/rhq/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install &&
    ./rhqctl start &&
    ./rhqctl status
