# jboss_fuse_621_ssh
Image to run JBoss Fuse 6.2.1 on 3 VMs.

## What does this image do?
- Creates 3 VMs
- Installs Fuse via scaffolding scripts (See: https://github.com/garethahealy/jboss-fuse-setup)
  - 3 Fabric (zookeeper) nodes
  - 1 ESB
  - 1 AMQ
  - 1 Gateway

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh machine1
- vagrant ssh machine2
- vagrant ssh machine3

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

## Log into hawt.io
- http://machine1.jbossfuse621.vagrant.local:8181
- U: admin
- P: admin

