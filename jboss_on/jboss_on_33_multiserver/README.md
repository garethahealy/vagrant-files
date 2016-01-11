# jboss_on_33_multiserver
Image to run JBoss ON 3.3 with multiple JON Servers running.

## What does this image do?
- Creates 4 VMs
  - Postgres DB
  - 2 JON Servers
  - JON Agent with JBoss Fuse running

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh jonservermulti1
- vagrant ssh jonservermulti2
- vagrant ssh jonagentmulti
- vagrant ssh postgresmutli1
- vagrant ssh postgresmutli2

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

## Log into JON
- http://jonservermulti1.jbosson33.vagrant.local:7080/
- http://jonservermulti2.jbosson33.vagrant.local:7080/
- U: rhqadmin
- P: rhqadmin

