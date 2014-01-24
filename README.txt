
Step 1. Log into the dashboard with admin credentials (as set in the cloud.conf file)
 - Go to the project panel, the Access & Security tab, and click on "API Access". Download OpenStack RC File.
 (Edit it to include the password for now).

Step 2. Go to the "Networks" Tab, click on "cloud" network. Write down the ID. Repeat with the "Public" network.
 - 3b9e14ce-cb78-4cfa-9215-6b0914a22394 (cloud)
 - b03b001a-2c45-444d-a0d4-4672306d52be (public)

Step 3. Tab "Images and Snapshots", Create Image. Use http://uec-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img and make it public. Name it "raring" and write down the ID.

Step 4. Source the openstack rc file and run your bootstrap script.
 - It will create the right flavors, and boot an inception VM.
 export INCEPTION_VM=`python bootstrap.sh`
 <wait a few minutes here...>
 scp admin-openrc-RegionOne.sh ubuntu@$INCEPTION_VM:~/credentials.sh
 ssh ubuntu@$INCEPTION_VM 'bash -s' < inception-strap.sh










AXLE INCEPTION:

Cloud Init:

 - Admin Credentials to cloud, with endpoints
	- Will query for "public" and "cloud" networks (and use the right net_ids)
	- Will allocate public IP
	- Will create tenant and flavors and user
 - Public IP addresses to use for manifest
 - DNS zone to use
 - Will use default state timeouts
 - Will use default number of retries


Start with Cloud.conf settings:

 - Fast Delete
 - Images to auto-upload:
	- http://uec-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img



QUESTIONS:


Ruby version: 1.9.3 (484)
Ruby installer: rbenv

state_timeout

How much disk is required?
Is ephemeral actually required? YES. (NO!)
10GB for CF
(Don't use reuse compile vms in prod)



Scheduler options for placement

Tenant per bosh?
Or shared tenants
 - shared is fine.

bosh cck (to clean up instance pools)

Can stemcells be shared between bosh and CF?
Why do you trigger a deploy by pointing it at a stemcell?


PERSON LIST:

BOSH OPENSTACK CPI (DMITRI and FERDY)
BATS
 - Location of key file
 - BOSH_KEY_PATH env variable

YETI (getting deprecated to CAT instead of YETI)


Releases




ALSO ALL OPEN SOURCE:


TO INCLUDE IN TRIALS: (RELEASE 147)

 - Stemcell tarball
   - VMS Agent
   - Ganglia as bosh job

Bosh CPI for VMS OpenStack

Bosh registry vs. Upload
Release registry vs. upload vs build

Fixed net_id for cloud and public
third network - DMZ that can talk to services net

push admin creds in via cloud-init


@stewfox re networking


 - Release tarball / prebuilt uploaded release manifest thingy - FOR BOSH
 - Release tarball / prebuilt uploaded release manifest thingy - FOR CF
 - Inception VM ready to do some deploys



