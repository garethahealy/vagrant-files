#!/usr/bin/env bash

set -x

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
    unzip -od /opt/rh/jon-server-3.3.0.GA/plugins jon-plugin-pack-fuse-3.3.0.GA.zip &&
    unzip -od /opt/rh/jon-server-3.3.0.GA/plugins jon-plugin-pack-fuse-patch-3.3.0.GA-update-03.zip

# Overwritting patched files
mv /opt/rh/jon-server-3.3.0.GA/bin/rhqctl.new /opt/rh/jon-server-3.3.0.GA/bin/rhqctl
mv /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties.new /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

# Config JON
sudo sed -i "s/rhq.server.database.server-name=127.0.0.1/rhq.server.database.server-name=jon-server/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/rhq.server.database.connection-url=jdbc:postgresql:\/\/127.0.0.1:5432\/rhq/rhq.server.database.connection-url=jdbc:postgresql:\/\/postgres.jbosson33.vagrant.local:5432\/rhq/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/rhq.autoinstall.server.admin.password=/rhq.autoinstall.server.admin.password=x1XwrxKuPvYUILiOnOZTLg==/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties
sudo sed -i "s/jboss.bind.address=/jboss.bind.address=0.0.0.0/" /opt/rh/jon-server-3.3.0.GA/bin/rhq-server.properties

#sudo chown -R jon:jon /opt/rh/jon-server-3.3.0.GA
#sudo -u jon /opt/rh/jon-server-3.3.0.GA/bin/rhqctl install --start

cd /opt/rh/jon-server-3.3.0.GA/bin &&
    ./rhqctl install &&
    ./rhqctl start &&
    ./rhqctl status


