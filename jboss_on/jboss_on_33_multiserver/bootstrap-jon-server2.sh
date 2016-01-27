#!/usr/bin/env bash

set -x

sed -i "s/rhq.autoinstall.public-endpoint-address=/rhq.autoinstall.public-endpoint-address=10.20.3.23/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/rhq.server.high-availability.name=/rhq.server.high-availability.name=10.20.3.23/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/rhq.storage.nodes=/rhq.storage.nodes=10.20.3.23,10.20.3.22/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/#rhq.storage.hostname=/rhq.storage.hostname=10.20.3.23/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-storage.properties

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install

# Configure the agent on the server
cd /opt/rh &&
    cp agent-configuration-template.xml rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#setup-flag/true/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#rhq.agent.name/jonservermulti2-agent/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#bind-address/10.20.3.23/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#server.bind-address/10.20.3.23/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#connector.transport/sslsocket/" rhq-agent/conf/agent-configuration.xml

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl start &&
    ./rhqctl status

# Check logs to see if server has started
echo "Waiting for server/agent/storage to start."

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

time_agent_elapsed=0
has_agent_started=0
while (( $has_agent_started <= 0 ))
do
    sleep 5
    time_agent_elapsed=$((time_agent_elapsed + 5))
    has_agent_started=$(grep -c "Got agent registration request for new agent" /opt/rh/jon-server-3.3.0.GA/logs/server.log)
    if [[ $time_agent_elapsed -ge 120 ]]; then
        echo "Waited $time_agent_elapsed for server agent start. Exiting loop."
        break
    fi
done

if [[ $has_agent_started == 1 ]]; then
    echo "Server agent has started."
fi

time_storage_elapsed=0
has_storage_started=0
while (( $has_storage_started <= 0 ))
do
    sleep 5
    time_storage_elapsed=$((time_storage_elapsed + 5))
    has_storage_started=$(grep -c "Updating snapshot management schedules for StorageNode" /opt/rh/jon-server-3.3.0.GA/logs/server.log)
    if [[ $time_storage_elapsed -ge 120 ]]; then
        echo "Waited $time_storage_elapsed for server agent start. Exiting loop."
        break
    fi
done

if [[ $has_storage_started == 1 ]]; then
    echo "Server storage has started."
fi
