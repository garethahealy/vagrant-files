#!/usr/bin/env bash

# Enable firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Open port for Java remote debugging
sudo firewall-cmd --zone=public --add-port=8443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=53/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9101/tcp --permanent
sudo firewall-cmd --reload

# Install OSE
sudo systemctl enable openshift
sudo systemctl start openshift

# Pull docker images
docker pull jboss-fuse-6/fis-java-openshift
docker pull jboss-fuse-6/fis-karaf-openshift
docker pull jboss-amq-6/amq62-openshift

# Create image streams
oc login localhost:8443 --username="admin" --password="admin" --insecure-skip-tls-verify=true
oc new-project fis
oc create -n fis -f https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json
oc create -n fis -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/amq/amq62-basic.json
