#!/usr/bin/env bash

set -x

sed -i "s/rhq.autoinstall.public-endpoint-address=/rhq.autoinstall.public-endpoint-address=10.20.3.22/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/rhq.server.high-availability.name=/rhq.server.high-availability.name=10.20.3.22/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/#rhq.storage.hostname=/rhq.storage.hostname=10.20.3.22/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-storage.properties

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install

# Configure the agent on the server
cd /opt/rh &&
    cp agent-configuration-template.xml rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#setup-flag/true/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#rhq.agent.name/jonservermulti1-agent/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#bind-address/10.20.3.22/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#server.bind-address/10.20.3.22/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#connector.transport/sslsocket/" rhq-agent/conf/agent-configuration.xml

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl start &&
    ./rhqctl status

# Check logs to see if server has started
echo "Waiting for server to start."

time_elapsed=0
has_started=0
while (( $has_started <= 0 ))
do
    sleep 5
    time_elapsed=$((time_elapsed + 5))
    has_started=$(grep -c "Server started." /opt/rh/jon-server-3.3.0.GA/logs/server.log)
    if [[ $time_elapsed -ge 120 ]]; then
        echo "Waited $time_elapsed for server start. Exiting loop."
        break
    fi
done

if [[ $has_started == 1 ]]; then
    echo "Server has started."
fi

# Update storage node address, as it sets its self as the hostname, which resolves to 127.0.0.1
export PGPASSWORD=rhqadmin &&
    psql -h postgresmulti.jbosson33.vagrant.local -U rhqadmin -d rhq -c "SELECT id, address FROM rhq_storage_node" &&
    psql -h postgresmulti.jbosson33.vagrant.local -U rhqadmin -d rhq -c "update rhq_storage_node set address = '10.20.3.22' where id = 1001"

# Wait for 1min, to give the server time to fully register the storage and agent node
sleep 120s
