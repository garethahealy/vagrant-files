jboss-fuse-61
=============================
Bare image to run JBoss Fuse 6.1 with patches.

What does this image do?
=============================
- Installs Fuse
- Starts up

Once the VM is up, you need to run 'scaffold-fuse-fabric.karaf', this is because a SSH session is lost when running fabric:create, so kills the script
