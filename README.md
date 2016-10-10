[![Build Status](https://travis-ci.org/garethahealy/vagrant-files.svg?branch=master)](https://travis-ci.org/garethahealy/vagrant-files)
[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# vagrant-files
- https://www.virtualbox.org/wiki/Downloads
- https://docs.vagrantup.com/v2/getting-started/
- https://blog.engineyard.com/2014/building-a-vagrant-box

## Boxes
- https://github.com/boxcutter
- https://atlas.hashicorp.com/boxes/search

- vagrant box add boxcutter/centos72 --provider virtualbox
- vagrant box add centos/atomic-host --provider virtualbox
- vagrant box add garethahealy/centos72_java8 --provider virtualbox

## IPs
- Fuse SSH:             10.20.1.11 -> 10.20.1.13
- Fuse Child:           10.20.1.21
- Fuse Puppet Chuld:    10.20.1.31
- Apache Artemis:       10.20.2.11 -> 10.20.2.21
- JON:                  10.20.3.11
- JON MultiServer:      10.20.3.21 -> 10.20.3.25
- EAP:                  10.20.4.11
- BRMS:                 10.20.5.11
- MariaDB:              10.20.6.11
- Jenkins:              10.20.7.11
- OpenShift:            10.1.2.2

## Pre-reqs
### Plugins
- vagrant plugin install vagrant-hostmanager
- vagrant plugin install vagrant-vbguest
- vagrant plugin install vagrant-cachier
- vagrant plugin install vagrant-triggers
- vagrant plugin install vagrant-auto_network

## Base for new project
- vagrant init garethahealy/centos72_java8; vagrant up --provider virtualbox
