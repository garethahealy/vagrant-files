# vagrant-files
- https://www.virtualbox.org/wiki/Downloads
- https://docs.vagrantup.com/v2/getting-started/
- https://blog.engineyard.com/2014/building-a-vagrant-box

## Boxes
- https://github.com/boxcutter
- https://atlas.hashicorp.com/boxes/search

- vagrant box add boxcutter/centos72 --provider virtualbox
- vagrant box add centos/atomic-host --provider virtualbox

## Pre-reqs
### Plugins
- vagrant plugin install vagrant-hostmanager
- vagrant plugin install vagrant-vbguest
- vagrant plugin install vagrant-cachier
- vagrant plugin install vagrant-triggers
- vagrant plugin install vagrant-auto_network

## Base for new project
- vagrant init garethahealy/centos72_java8; vagrant up --provider virtualbox
