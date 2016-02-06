# OpenShift 3.1 based on CDK
This image is based on the CDK. To download the vagrant image, you require a valid subscription.

- https://access.redhat.com/documentation/en/red-hat-enterprise-linux-atomic-host/version-7/container-development-kit-guide
- https://access.redhat.com/downloads/content/293/ver=2/rhel---7/2.0.0/x86_64/product-software/

## Usage
- vagrant up

## Login
### Admin/Test user
- oc login localhost:8443 --username="admin" --password="admin" --insecure-skip-tls-verify=true

### System user
- oc login 10.0.2.15:8443 --username=system:admin -n default
