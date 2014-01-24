PROJECT AXLE: DEVCLOUD with OpenStack and Cloud Foundry
-------------------------------------------------------

1. Set up Piston OpenStack 3.0 with CF-friendly config options:
 - Fast Delete
 - GroupAntiAffinity filters enabled
 - LVM CoW enabled for fast stemcell launching

1. Log into the dashboard with admin credentials (as set in the cloud.conf file)
 - Go to the project panel, the Access & Security tab, and click on "API Access". Download OpenStack RC File.
 (Edit it to include the password for now).

1. Go to the "Networks" Tab, click on "cloud" network. Write down the ID. Repeat with the "Public" network.
 - 3b9e14ce-cb78-4cfa-9215-6b0914a22394 (cloud)
 - b03b001a-2c45-444d-a0d4-4672306d52be (public)

1. Tab "Images and Snapshots", Create Image. Use http://uec-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img and make it public. Name it "raring" and write down the ID.

1. Go to the admin panel, Projects, and set quota for the admin project to -1 for every field.
_TODO: do this in inception.sh instead_

1. Customize your openstack rc file:
 - Include your password
 - Add the cloud net id
 - Allocate a floating ip for bosh and add it
 - Allocate a static IP for bosh and add it
 - Allocate a floating ip for BATS and add it
 - Allocate a floating ip for CF and add it
 - Add your wildcarded DNS for that IP

```bash
export cloud_net_id=3b9e14ce-cb78-4cfa-9215-6b0914a22394
export allocated_floating_ip=205.234.30.254
export static_ip=10.2.3.100
export bat_floating_ip=205.234.30.253
export CF_FLOATING_IP=205.234.30.252
export DNS_SUBZONE=somegood.org
```

_TODO: default number of retries_

1. Source the openstack rc file and run your bootstrap script. It will create the right flavors, and boot an inception VM.

```bash

export INCEPTION_VM=`python bootstrap.sh`
# wait a few minutes here...
scp ~/Downloads/admin-openrc-RegionOne.sh ubuntu@$INCEPTION_VM:~/credentials.sh
ssh ubuntu@$INCEPTION_VM 'bash -s' < inception-strap.sh
```


1. Run BAT to validate your BOSH environment
```bash
ssh ubuntu@$INCEPTION_VM 'bash -s' < bat-me.sh
```

1. Install CF as a BOSH Release
```bash
ssh ubuntu@$INCEPTION_VM 'bash -s' < cf-me.sh
```

_TODO: don't hardcode private ranges, use dynamic for now._

1. Install an app on CF to prove it worked:
```bash
gem install cf
cf target http://api.$DNS_SUBZONE
cf login
cf create-org demo
cf create-space development
cf switch-space development
git clone https://github.com/cloudfoundry-community/cf_demoapp_ruby_rack.git
cd cf_demoapp_ruby_rack/
bundle 
cf push
cf app hello
cf push --instances 5
```
