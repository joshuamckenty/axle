#!/usr/bin/env bash

# source /usr/local/share/chruby/chruby.sh
# chruby ruby-2.0.0-p247
# ./bosh-bootstrap/bin/bosh-bootstrap deploy

sudo apt-get update
sudo apt-get install -y git-core build-essential libsqlite3-dev curl rsync git-core libmysqlclient-dev libxml2-dev libxslt-dev libpq-dev libsqlite3-dev libcurl4-gnutls-dev runit genisoimage debootstrap kpartx qemu-kvm whois tmux vim
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
source /home/ubuntu/.rvm/scripts/rvm
git clone https://github.com/cloudfoundry/bosh.git
cd bosh
bundle install --binstubs
export PATH=$(pwd)/bin:$PATH

# PUSH IN CREDENTIALS HERE
source ~/credentials.sh

ssh-keygen -q -f ~/.ssh/microbosh -N ''
mkdir -p ~/bosh-workspace/deployments/microbosh-openstack
cd ~/bosh-workspace/deployments/microbosh-openstack
curl -O https://gist.github.com/joshuamckenty/8590122/raw/8948e93cea6ad327e03fc202e800ac249780f466/micro_bosh.yml

sed -i -e s/\$os_password/$OS_PASSWORD/g ~/bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml
sed -i -e s/\$identity_server/$OS_AUTH_URL/g bosh-workspace/deployments/microbosh-openstack/micro_bosh.yml