#!/usr/bin/env bash

set -x

# ulimits values need to be higher for this process
ulimit -u 4096
ulimit -n 4096

# Open web ui
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# Install Docker
sudo yum install -y docker-1.8.2

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

# Add the Jenkins repo and install
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
sudo yum install -y jenkins

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins


# Install any plugins
curl -X POST -d '<jenkins><install plugin="docker-commons@1.2" /></jenkins>' --header 'Content-Type: text/xml' http://localhost:8080/pluginManager/installNecessaryPlugins

# Wait just so everything is installed
sleep 30

# Jenkins safe restart
curl -X POST http://localhost:8080/safeRestart
