#!/usr/bin/env bash

source /home/ubuntu/.rvm/scripts/rvm
export PATH=~/bosh/bin:$PATH

source ~/credentials.sh

export BAT_DIRECTOR=$allocated_floating_ip
export BAT_STEMCELL="/home/ubuntu/bosh-workspace/stemcells/bosh-stemcell-latest-openstack-kvm-ubuntu.tgz"
export BAT_DEPLOYMENT_SPEC="/home/ubuntu/bosh-workspace/bat-openstack-dynamic.yml"
export BAT_VCAP_PASSWORD="c1oudc0w"
export BAT_DNS_HOST=$allocated_floating_ip
export BOSH_KEY_PATH="/home/ubuntu/.ssh/microbosh"
export BAT_BOSH_BIN="/home/ubuntu/bosh"
# TODO
export BOSH_UUID="41b2be0e-6a9c-4a88-a227-277a6823c79c"

cd ~/bosh-workspace/

curl -O https://gist.github.com/joshuamckenty/8592587/raw/bat-openstack-dynamic.yml.template
curl -O https://gist.github.com/joshuamckenty/8592327/raw/replace.sh
chmod a+x replace.sh
./replace.sh bat-openstack-dynamic.yml.template bat-openstack-dynamic.yml ~/credentials.sh

cd ~/bosh/bat/
bundle exec rake bat:env
bundle exec rake bat