# jboss_on_33_multiserver
Image to run JBoss ON 3.3 with multiple JON Servers running. This is to show: https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Operations_Network/3.3/html/Admin_and_Config/configuring-high-availability.html

## What does this image do?
- Creates 5 VMs
  - Postgres DB
  - 2 JON Servers
  - 2 JON Agents with JBoss Fuse running

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh jonservermulti1
- vagrant ssh jonservermulti2
- vagrant ssh jonagentmulti1
- vagrant ssh jonagentmulti2
- vagrant ssh postgresmutli

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

## Log into JON
- http://jonservermulti1.jbosson33.vagrant.local:7080/
- http://jonservermulti2.jbosson33.vagrant.local:7080/
- U: rhqadmin
- P: rhqadmin


## TODO:
Seem to get the below error when trying to run the start script for fuse

=> jonagentmulti1: bash: line 3: xit: command not found
The SSH command responded with a non-zero exit status. Vagrant
assumes that this means the command failed. The output for this command
should be in the log above. Please read the output to determine what
went wrong.

