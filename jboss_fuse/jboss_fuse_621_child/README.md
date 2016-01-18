# jboss_fuse_621
Image to run JBoss Fuse 6.2.1 on a single VM.

## What does this image do?
- Creates 1 VM
- Installs Fuse via scaffolding scripts (See: https://github.com/garethahealy/jboss-fuse-setup)
  - 1 Fabric (zookeeper)
  - 1 ESB
  - 1 AMQ
  - 1 Gateway

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

## Log into hawt.io
- http://machine1.jbossfuse621.vagrant.local:8181
- U: admin
- P: admin

