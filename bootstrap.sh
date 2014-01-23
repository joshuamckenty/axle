#!/usr/bin/env python

# nova keypair-add --pub-key ~/.ssh/id_rsa.pub josh-macbook-air
# nova flavor-create --is-public true m1.microbosh 1337 4096 20 2
# 
# nova boot --flavor m1.microbosh --image-with Checksum=243b5ab4d68d1e22321f247ab8ae912d --num-instances 1 --key-name josh-macbook-air --nic net-id=

import os

def get_keystone_creds():
    d = {}
    d['username'] = os.environ['OS_USERNAME']
    d['password'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    d['tenant_name'] = os.environ['OS_TENANT_NAME']
    return d

def get_nova_creds():
    d = {}
    d['username'] = os.environ['OS_USERNAME']
    d['api_key'] = os.environ['OS_PASSWORD']
    d['auth_url'] = os.environ['OS_AUTH_URL']
    d['project_id'] = os.environ['OS_TENANT_NAME']
    return d

from novaclient import client as novaclient
import keystoneclient.v2_0.client as ksclient
creds = get_nova_creds()
nova = novaclient.Client("1.1", **creds)
keystone = ksclient.Client(**get_keystone_creds())

try:
	nova.keypairs.create(name="josh-macbook-air", public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDc9iYBRNy1A5ZDxufmSWChvRe36Bq4pSlpDMUPnz43oKDYMn9b9u5RuyDPiFAktj8ClbRtZhh3o5fzYCci9rNHkSnbSQed0fAmi/osE4oGkS3NmS64z0cat+QOf/BmUljdNSoFI4tFTdTWrgdLXo32ji3bMiMIE8d8jhxYYtcHETlzsI8XNPFufTbzYERGXG5qGQ1uiBFzhWuxb+5jyLjQC6fiuouEqQD7H0+sLLmB94Em4SYZLCf5frJqFkmehMSWEHZ7+Xr3APUpT+hNO/gF/oroTkN39sMzlbAkr2f8Qy160F14qEKvTTuqQ08NtXbWHFTpYk4yqL8UvU9hTri9 joshuamckenty@Joshuas-MacBook-Air.local")
except:
	pass
	
try:
	nova.flavors.delete(nova.flavors.find(name="m1.small"))
except:
	pass
try:
	nova.flavors.delete(nova.flavors.find(name="m1.microbosh"))
except:
	pass
try:
	nova.flavors.create(name="m1.small", ram="4096", vcpus="2", disk="10", ephemeral="0", flavorid="auto")
	nova.flavors.create(name="m1.microbosh", ram="4096", vcpus="2", disk="10", flavorid="auto")
except:
	pass


try:
	keystone.tenants.create('cloudfoundry')
except:
	pass

try:
	keystone.tenants.find(name='cloudfoundry').add_user(keystone.users.find(name='admin'),keystone.roles.find(name='Admin'))
except:
	pass	

fip = nova.floating_ips.create(nova.networks.find(label="public").id)

server = nova.servers.create(name='inception', 
	image = nova.images.find(name="raring"), 
	flavor = nova.flavors.find(name="m1.microbosh"), 
	key_name = "josh-macbook-air", 
	nics = [{'net-id' : nova.networks.find(label="cloud").id}] )

server.add_floating_ip(fip)
print fip.ip