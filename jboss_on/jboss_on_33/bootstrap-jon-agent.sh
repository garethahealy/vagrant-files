#!/usr/bin/env bash

set -x

# Run scaffolding scripts to install JBoss Fuse
cd /tmp &&
    unzip -o scaffolding-scripts.zip &&
    cd scripts &&
    chmod -R 755 ./*.sh &&
    ./install-fuse.sh -e vagrant-child

# Start Fuse
cd /opt/rh/jboss-fuse-6.2.1.redhat-084/bin &&
    ./start

# Install the agent
cd /opt/rh &&
    wget -O jon-agent-4.12.0.JON330GA.jar http://jonserver.jbosson33.vagrant.local:7080/agentupdate/download &&
    java -jar jon-agent-4.12.0.JON330GA.jar --install &&
    cp agent-configuration-template.xml rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#setup-flag/true/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#rhq.agent.name/jonagent/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#bind-address/10.20.3.13/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#server.bind-address/jonserver.jbosson33.vagrant.local/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#connector.transport/sslsocket/" rhq-agent/conf/agent-configuration.xml &&
    cd rhq-agent/bin &&
    ./rhq-agent-wrapper.sh start &&
    ./rhq-agent-wrapper.sh status

time_agent_elapsed=0
has_agent_started=0
while (( has_agent_started <= 0 ))
do
    sleep 5
    time_agent_elapsed=$((time_agent_elapsed + 5))
    has_agent_started=$(grep -c "Executing server discovery scan" /opt/rh/rhq-agent/logs/agent.log)
    if [[ $time_agent_elapsed -ge 120 ]]; then
        echo "Waited $time_agent_elapsed for agent scan. Exiting loop."
        break
    fi
done

if [[ $has_agent_started == 1 ]]; then
    echo "Agent has completed scan."
fi

exit 0;
