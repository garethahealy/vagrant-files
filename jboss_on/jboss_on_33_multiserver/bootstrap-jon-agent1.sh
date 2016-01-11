#!/usr/bin/env bash

set -x

# Install the agent
cd /opt/rh &&
    wget -O jon-agent-4.12.0.JON330GA.jar http://jonservermulti1.jbosson33.vagrant.local:7080/agentupdate/download &&
    java -jar jon-agent-4.12.0.JON330GA.jar --install &&
    mv agent-configuration-template.xml rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#setup-flag/true/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#connector.transport/sslsocket/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#rhq.agent.name/jonagent1/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#bind-address/10.20.3.24/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#server.bind-address/jonservermulti1.jbosson33.vagrant.local/" rhq-agent/conf/agent-configuration.xml &&
    cd rhq-agent/bin &&
    ./rhq-agent-wrapper.sh start
