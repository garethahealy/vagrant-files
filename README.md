[![Build Status](https://travis-ci.org/garethahealy/vagrant-files.svg?branch=master)](https://travis-ci.org/garethahealy/vagrant-files)
[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# vagrant-files
- https://www.virtualbox.org/wiki/Downloads
- https://www.vagrantup.com/intro/getting-started/
- https://www.engineyard.com/blog/building-a-vagrant-box

## Boxes
- https://app.vagrantup.com/boxes/search

- vagrant box add centos/7 --provider virtualbox
- vagrant box add garethahealy/centos7_java8 --provider virtualbox

## IPs
- Fuse SSH:             10.20.1.11 -> 10.20.1.13
- Fuse Child:           10.20.1.21
- Fuse Puppet Chuld:    10.20.1.31
- Apache Artemis:       10.20.2.11 -> 10.20.2.21
- JON:                  10.20.3.11
- JON MultiServer:      10.20.3.21 -> 10.20.3.25

## Pre-reqs
### Plugins
- vagrant plugin install vagrant-hostmanager
- vagrant plugin install vagrant-vbguest
- vagrant plugin install vagrant-cachier
- vagrant plugin install vagrant-triggers
- vagrant plugin install vagrant-auto_network

## Base for new project
- vagrant init garethahealy/centos7_java8; vagrant up --provider virtualbox
