#!/usr/bin/env python

# nova keypair-add --pub-key ~/.ssh/id_rsa.pub josh-macbook-air

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

try:
	secgroup = nova.security_groups.find("bosh")
except:
	secgroup = nova.security_groups.create("bosh", "Bosh Security Group")
	nova.security_group_rules.create(secgroup.id, ip_protocol="icmp",
	                                 from_port=-1, to_port=-1)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=1, to_port=65535, group_id=secgroup.id)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=4222, to_port=4222)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=53, to_port=53)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=25777, to_port=25777)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=25555, to_port=25555)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=25252, to_port=25252)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=6868, to_port=6868)
	nova.security_group_rules.create(secgroup.id, ip_protocol="udp",
	                                 from_port=53, to_port=53)
	nova.security_group_rules.create(secgroup.id, ip_protocol="udp",
	                                 from_port=68, to_port=68)

try:
	secgroup = nova.security_groups.find("ssh")
except:
	secgroup = nova.security_groups.create("ssh", "SSH Security Group")
	nova.security_group_rules.create(secgroup.id, ip_protocol="icmp",
	                                 from_port=-1, to_port=-1)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=22, to_port=22)
	nova.security_group_rules.create(secgroup.id, ip_protocol="udp",
	                                 from_port=68, to_port=68)

try:
	secgroup = nova.security_groups.find("cf-public")
except:
	secgroup = nova.security_groups.create("cf-public", "CF-Public Group")
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=80, to_port=80)
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=443, to_port=443)
	nova.security_group_rules.create(secgroup.id, ip_protocol="udp",
	                                 from_port=68, to_port=68)

try:
	secgroup = nova.security_groups.find("cf-private")
except:
	secgroup = nova.security_groups.create("cf-private", "CF-Private Group")
	nova.security_group_rules.create(secgroup.id, ip_protocol="tcp",
	                                 from_port=1, to_port=65535, group_id=secgroup.id)
	nova.security_group_rules.create(secgroup.id, ip_protocol="udp",
	                                 from_port=68, to_port=68)


fip = nova.floating_ips.create(nova.networks.find(label="public").id)

server = nova.servers.create(name='inception', 
	image = nova.images.find(name="raring"), 
	flavor = nova.flavors.find(name="m1.microbosh"), 
	key_name = "josh-macbook-air", 
	nics = [{'net-id' : nova.networks.find(label="cloud").id}] )

server.add_floating_ip(fip)
print fip.ip