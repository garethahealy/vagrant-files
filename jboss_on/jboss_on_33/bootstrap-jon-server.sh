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

sudo chown -R jon:jon /opt/rh/jon-server-3.3.0.GA
sudo -u jon /opt/rh/jon-server-3.3.0.GA/bin/rhqctl install --start

## todo: need to provide options
