# jboss_eap
Image to run JBoss BRMS 6.2.

## What does this image do?
- Creates a VM running JBoss BRMS

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh brmsserver

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

