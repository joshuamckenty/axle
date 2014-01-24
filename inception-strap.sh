#!/usr/bin/env bash

source ~/credentials.sh

sudo apt-get update
sudo apt-get install -y git-core build-essential libsqlite3-dev curl rsync git-core libmysqlclient-dev libxml2-dev libxslt-dev libpq-dev libsqlite3-dev libcurl4-gnutls-dev runit genisoimage debootstrap kpartx qemu-kvm whois tmux vim
sudo apt-get install -y python-novaclient
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
source /home/ubuntu/.rvm/scripts/rvm

git clone https://github.com/cloudfoundry/bosh.git
cd bosh
bundle install --binstubs
export PATH=~/bosh/bin:$PATH


ssh-keygen -q -f ~/.ssh/microbosh -N ''
mkdir -p ~/bosh-workspace/deployments/microbosh-openstack
cd ~/bosh-workspace/deployments/microbosh-openstack
curl -O https://gist.github.com/joshuamckenty/8590122/raw/micro_bosh.yml.template
curl -O https://gist.github.com/joshuamckenty/8592327/raw/replace.sh
chmod a+x replace.sh
./replace.sh micro_bosh.yml.template micro_bosh.yml ~/credentials.sh

mkdir -p ~/bosh-workspace/stemcells
cd ~/bosh-workspace/stemcells
wget http://bosh-jenkins-artifacts.s3.amazonaws.com/bosh-stemcell/openstack/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz

cd ~/bosh-workspace/deployments
bosh micro deployment microbosh-openstack

bosh -n micro deploy ~/bosh-workspace/stemcells/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz

# DO ME BY HAND
# bosh target $allocated_floating_ip
