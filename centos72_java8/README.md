# centos72_java8 - [download](https://atlas.hashicorp.com/garethahealy/boxes/centos72_java8)
Base image for any Java related projects. Provides JDK and all pre-reqs.

## Re-package box
- vagrant destroy
- vagrant up
- vagrant package --output centos72_java8.box
- vagrant box add centos72_java8 centos72_java8.box



http://stackoverflow.com/questions/28328775/virtualbox-mount-vboxsf-mounting-failed-with-the-error-no-such-device
sudo yum -y install gcc kernel-devel make
cd /opt/VBoxGuestAdditions-*/init
sudo ./vboxadd setup
