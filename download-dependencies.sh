#!/usr/bin/env bash

# Configure logging to print line numbers
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Set colours
GREEN="\e[32m"
WHITE="\e[0m"

if [ ! -f "$HOME/.m2/repository/org/apache/activemq/activemq-artemis/2.0.0/activemq-artemis-2.0.0-bin.zip" ]; then
    curl -L https://www.apache.org/dist/activemq/activemq-artemis/2.0.0/apache-artemis-2.0.0-bin.zip -o apache-artemis-2.0.0-bin.zip
    mvn install:install-file -Dfile=apache-artemis-2.0.0-bin.zip -DgroupId=org.apache.activemq -DartifactId=activemq-artemis -Dversion=2.0.0 -Dpackaging=zip -Dclassifier=bin
fi

ls -lrt "$HOME/.m2/repository/org/apache/activemq/activemq-artemis/2.0.0/activemq-artemis-2.0.0-bin.zip"

echo -e "$GREEN As JBoss downloads require a login, you need to go to: http://developers.redhat.com/downloads/ $WHITE"
echo -e "$GREEN The below are provided as helpful links: $WHITE"
echo ""
echo -e "$GREEN https://developers.redhat.com/download-manager/file/jboss-eap-7.0.0-installer.jar $WHITE"
echo -e "$GREEN https://developers.redhat.com/download-manager/file/jboss-fuse-6.2.0.GA-full_zip.zip $WHITE"
echo -e "$GREEN https://developers.redhat.com/download-manager/file/jboss-brms-6.3.0.GA-installer.jar $WHITE"
echo ""
echo -e "$GREEN Once downloaded, you can install via: http://maven.apache.org/plugins/maven-install-plugin/usage.html $WHITE"
echo -e "$GREEN i.e.: mvn install:install-file -Dfile=jboss-fuse-6.2.0.GA-full_zip.zip -DgroupId=org.jboss.fuse -DartifactId=jboss-fuse-full -Dversion=6.2.1.redhat-084 -Dpackaging=zip $WHITE"
