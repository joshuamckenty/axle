Step 0. Set up Piston OpenStack with CF-friendly config options:
 - Fast Delete
 - GroupAntiAffinity filters enabled
 - LVM CoW enabled for fast stemcell launching



Step 1. Log into the dashboard with admin credentials (as set in the cloud.conf file)
 - Go to the project panel, the Access & Security tab, and click on "API Access". Download OpenStack RC File.
 (Edit it to include the password for now).

Step 2. Go to the "Networks" Tab, click on "cloud" network. Write down the ID. Repeat with the "Public" network.
 - 3b9e14ce-cb78-4cfa-9215-6b0914a22394 (cloud)
 - b03b001a-2c45-444d-a0d4-4672306d52be (public)

Step 3. Tab "Images and Snapshots", Create Image. Use http://uec-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img and make it public. Name it "raring" and write down the ID.

Step 4. Customize your openstack rc file:
 - Include your password
 - Add the cloud net id
 - Allocate a floating ip for bosh and add it
 - Allocate a static IP for bosh and add it
 - Allocate a floating ip for BATS and add it

export cloud_net_id=3b9e14ce-cb78-4cfa-9215-6b0914a22394
export allocated_floating_ip=205.234.30.254
export static_ip=10.2.3.100
export bat_floating_ip=205.234.30.253

Step 4. Source the openstack rc file and run your bootstrap script.
 - It will create the right flavors, and boot an inception VM.
 export INCEPTION_VM=`python bootstrap.sh`
 <wait a few minutes here...>
 scp admin-openrc-RegionOne.sh ubuntu@$INCEPTION_VM:~/credentials.sh
 ssh ubuntu@$INCEPTION_VM 'bash -s' < inception-strap.sh


Step 5. Run BAT to validate your BOSH environment
 ssh ubuntu@$INCEPTION_VM 'bash -s' < bat-me.sh



# TODO: Set Quotas
# TODO: state timeouts
# TODO: default number of retries

BUILD ARTIFACTS TO INCLUDE IN AXLE PACKAGE: (RELEASE 147)

 - Custom Stemcell
   - VMS Agent
   - Ganglia as bosh job

Bosh CPI for VMS OpenStack
