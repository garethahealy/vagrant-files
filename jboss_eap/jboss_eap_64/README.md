## WORK IN PROGRESS

# jboss_eap
Image to run JBoss EAP 6.4.

## What does this image do?
- Creates a VM running JBoss EAP

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh eapserver

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

