#!/usr/bin/env bash

set -x

# https://www.sslshopper.com/article-how-to-create-a-self-signed-certificate-using-java-keytool.html
# Generate keystore (Server) and truststore (Agent)
keytool -genkey -keystore server-keystore.jks -alias jonserver  -storepass password -validity 360 -keysize 2048 -dname "CN=jonserver.jbosson33.vagrant.local, OU=Development, O=Gareth Healy, L=Sheffield, S=South Yorkshire, C=UK"
keytool -export -rfc -keystore server-keystore.jks -storepass password -alias jonserver -file jonserver.cer
keytool -import -trustcacerts -keystore client-truststore.jks -storepass password -file jonserver.cer -alias jonserver -noprompt

# Create JON user
sudo adduser jon
echo "jon" | sudo passwd "jon" --stdin

# Install JON and apply patches
cd /opt/rh &&
    unzip -o jon-server-3.3.0.GA.zip &&
    unzip -o jon-server-patch-3.3-update-04.zip
    jon-server-3.3.0.GA-update-04/apply-updates.sh /opt/rh/jon-server-3.3.0.GA

# Remove files before hotfix
cd /opt/rh/jon-server-3.3.0.GA &&
    rm -f jbossas/modules/system/layers/base/org/apache/commons/collections/main/commons-collections-3.2.1.redhat-3.jar &&
    rm -f jbossas/modules/system/layers/base/org/apache/commons/collections/main/module.xml &&
    rm -f modules/org/rhq/server-startup/main/deployments/rhq.ear/rhq-portal.war/WEB-INF/lib/commons-collections-3.2.1.jar &&
    rm -f modules/org/rhq/server-startup/main/deployments/rhq.ear/rhq-content_http.war/WEB-INF/lib/commons-collections-3.2.1.jar &&
    rm -f modules/org/rhq/server-startup/main/deployments/rhq.ear/lib/commons-collections-3.2.1.jar

# Apply hotfix
cd /opt/rh &&
    unzip -od /opt/rh/jon-server-3.3.0.GA patch-common-collections-BZ-1281514.zip

# Add Plugins
cd /opt/rh &&
    unzip -od /tmp/jonplugins jon-plugin-pack-fuse-3.3.0.GA.zip &&
    unzip -od /tmp/jonplugins jon-plugin-pack-eap-3.3.0.GA.zip &&
    unzip -od /tmp/jonplugins jon-plugin-pack-brms-3.3.0.GA.zip &&
    unzip -od /tmp/jonplugins jon-plugin-pack-fuse-patch-3.3.0.GA-update-03.zip &&
    unzip -od /tmp/jonplugins jon-plugin-pack-eap-patch-3.3.0.GA-update-01.zip &&
    unzip -od /tmp/jonplugins jon-plugin-pack-brms-patch-3.3.0.GA-update-01.zip &&
    mv /tmp/jonplugins/jon-plugin-pack-fuse-3.3.0.GA/* /opt/rh/jon-server-3.3.0.GA/plugins &&
    mv /tmp/jonplugins/jon-plugin-pack-eap-3.3.0.GA/* /opt/rh/jon-server-3.3.0.GA/plugins &&
    mv /tmp/jonplugins/jon-plugin-pack-brms-bpms-3.3.0.GA/* /opt/rh/jon-server-3.3.0.GA/plugins &&
    mv /tmp/jonplugins/plugins/* /opt/rh/jon-server-3.3.0.GA/plugins

# Overwritting patched files
mv /opt/rh/jon-server-3.3.0.GA/bin/rhqctl.new /opt/rh/jon-server-3.3.0.GA/bin/rhqctl
mv /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties.new /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# Config JON settings
sed -i "s/rhq.autoinstall.server.admin.password=/rhq.autoinstall.server.admin.password=x1XwrxKuPvYUILiOnOZTLg==/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/jboss.bind.address=/jboss.bind.address=0.0.0.0/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# Config JON DB settings
sed -i "s/rhq.server.database.server-name=127.0.0.1/rhq.server.database.server-name=postgres.jbosson33.vagrant.local/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sed -i "s/rhq.server.database.connection-url=jdbc:postgresql:\/\/127.0.0.1:5432\/rhq/rhq.server.database.connection-url=jdbc:postgresql:\/\/postgres.jbosson33.vagrant.local:5432\/rhq/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Operations_Network/3.3/html/Admin_and_Config/configuring-ssl.html
# Config JON SSL Server <-> Agent
sudo sed -i "s/rhq.communications.connector.transport=servlet/rhq.communications.connector.transport=sslservlet/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install

# Configure the agent on the server
cd /opt/rh &&
    cp agent-configuration-template.xml rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#setup-flag/true/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#rhq.agent.name/jonserveragent/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#bind-address/10.20.3.12/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#server.bind-address/jonserver.jbosson33.vagrant.local/" rhq-agent/conf/agent-configuration.xml &&
    sed -i "s/#connector.transport/sslsocket/" rhq-agent/conf/agent-configuration.xml

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl start &&
    ./rhqctl status

# Check logs to see if server has started
echo "Waiting for server/agent/storage to start."

time_elapsed=0
has_started=0
while (( has_started <= 0 ))
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
while (( has_agent_started <= 0 ))
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
while (( has_storage_started <= 0 ))
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

