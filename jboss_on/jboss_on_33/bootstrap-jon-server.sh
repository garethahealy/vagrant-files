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
    unzip jon-server-3.3.0.GA.zip &&
    unzip jon-server-patch-3.3-update-04.zip
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

# Add Fuse plugins
cd /opt/rh &&
    unzip -d /tmp/jonplugins jon-plugin-pack-fuse-3.3.0.GA.zip &&
    unzip -d /tmp/jonplugins jon-plugin-pack-fuse-patch-3.3.0.GA-update-03.zip
    mv /tmp/jonplugins/jon-plugin-pack-fuse-3.3.0.GA/* /opt/rh/jon-server-3.3.0.GA/plugins &&
    mv /tmp/jonplugins/plugins/* /opt/rh/jon-server-3.3.0.GA/plugins

# Overwritting patched files
mv /opt/rh/jon-server-3.3.0.GA/bin/rhqctl.new /opt/rh/jon-server-3.3.0.GA/bin/rhqctl
mv /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties.new /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# Config JON settings
sudo sed -i "s/rhq.autoinstall.server.admin.password=/rhq.autoinstall.server.admin.password=x1XwrxKuPvYUILiOnOZTLg==/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/jboss.bind.address=/jboss.bind.address=0.0.0.0/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# Config JON DB settings
sudo sed -i "s/rhq.server.database.server-name=127.0.0.1/rhq.server.database.server-name=postgres.jbosson33.vagrant.local/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/rhq.server.database.connection-url=jdbc:postgresql:\/\/127.0.0.1:5432\/rhq/rhq.server.database.connection-url=jdbc:postgresql:\/\/postgres.jbosson33.vagrant.local:5432\/rhq/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Operations_Network/3.3/html/Admin_and_Config/configuring-ssl.html
# Config JON SSL Server <-> Agent
sudo sed -i "s/rhq.communications.connector.transport=servlet/rhq.communications.connector.transport=sslservlet/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

#sudo chown -R jon:jon /opt/rh/jon-server-3.3.0.GA
#sudo -u jon /opt/rh/jon-server-3.3.0.GA/bin/rhqctl install --start

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install &&
    ./rhqctl start &&
    ./rhqctl status
