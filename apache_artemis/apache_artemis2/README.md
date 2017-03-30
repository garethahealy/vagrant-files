# apache_artemis2
Image to run Apache Artemis 2.0.0.

## What does this image do?
- Creates 1 VM
- Installs and Starts Apache Artemis

## How to run
- mvn clean install -Pdependencies
- vagrant up
- vagrant ssh

### Why do i need to mvn clean install?
The vagrant file expects to find any pre-req files in your m2 directory

