jboss-fuse-61
=============================
Bare image to run JBoss Fuse 6.1 with patches.

What does this image do?
=============================
- Installs Fuse
- Starts up

Once the VM is up, you need to run 'scaffold-fuse-fabric.karaf', this is because a SSH session is lost when running fabric:create, so kills the script

- vagrant init base_java_vagrant
- vagrant up
- vagrant ssh

NOTES
=============================
Sometimes the IP for 'enp0s8' doesnt startup, run:

sudo /etc/init.d/network restart
ifconfig


Check if hawtio is working
=============================
ping jbossfuse61.vagrant.local
nmap -p 8181 jbossfuse61.vagrant.local

Safari for some reason doesnt like the url, but works in chrome

