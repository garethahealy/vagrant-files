# centos72_java8 - [download](https://atlas.hashicorp.com/garethahealy/boxes/centos72_java8)
Base image for any Java related projects. Provides JDK and all pre-reqs.

## Re-package box
- vagrant destroy
- vagrant up
- vagrant package --output centos72_java8.box
- vagrant box add centos72_java8 centos72_java8.box

## Push to Atlas
- https://www.vagrantup.com/docs/push/atlas.html
- https://github.com/mitchellh/vagrant/issues/4968

