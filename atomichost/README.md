# atomichost
Base image for any Docker related projects running on Atomic Host.

## Re-package box
- vagrant destroy
- vagrant up
- vagrant package --output atomichost.box
- vagrant box add atomichost atomichost.box
