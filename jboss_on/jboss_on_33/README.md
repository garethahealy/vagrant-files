# jboss_on_33
Image to run JBoss ON 3.3.

## What does this image do?
- Creates 3 VMs
  - Postgres DB
  - JON Server
  - JON Agent with JBoss Fuse running

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh jonserver
- vagrant ssh jonagent
- vagrant ssh postgres

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

## Log into JON
- http://jonserver.jbosson33.vagrant.local:7080/
- U: rhqadmin
- P: rhqadmin

## TODO:
Seem to get the below error when trying to run the start script for jon agent

==> jonagent: bash: line 3: xit: command not found
The SSH command responded with a non-zero exit status. Vagrant
assumes that this means the command failed. The output for this command
should be in the log above. Please read the output to determine what
went wrong.
