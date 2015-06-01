vagrant-files
=============================
https://docs.vagrantup.com/v2/getting-started

Pre-reqs
- vagrant plugin install vagrant-vbguest
- vagrant plugin install vagrant-auto_network
- vagrant plugin install vagrant-triggers
- vagrant box add puppetlabs/centos-7.0-64-puppet

- vagrant up
- vagrant package --output base_java_vagrant.box
- vagrant box add base_java_vagrant base_java_vagrant.box

- vagrant init base_java_vagrant
- vagrant ssh

NOTES
===
Sometimes the IP for 'enp0s8' doesnt startup, run:

sudo /etc/init.d/network restart
ifconfig

Check if hawtio is working
===============================
ping jbossfuse61.vagrant.local
nmap -p 8181 jbossfuse61.vagrant.local

Safari for some reason doesnt like the url, but works in chrome
