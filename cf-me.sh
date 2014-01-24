#!/usr/bin/env bash

source /home/ubuntu/.rvm/scripts/rvm
source ~/credentials.sh

export PATH=~/bosh/bin:$PATH
# TODO
export BOSH_UUID="41b2be0e-6a9c-4a88-a227-277a6823c79c"

mkdir -p ~/bosh-workspace/releases
cd ~/bosh-workspace/releases
git clone -b release-candidate git://github.com/cloudfoundry/cf-release.git
cd cf-release
bosh upload release releases/cf-154.yml

cd ~/bosh-workspace/releases
git clone git@github.com:cloudfoundry-community/admin-ui-boshrelease.git
cd admin-ui-boshrelease
bosh upload release releases/admin-ui-2.yml

cd ~/bosh-workspace/releases
git clone https://github.com/cloudfoundry/cf-services-contrib-release.git
cd cf-services-contrib-release/
bosh upload release releases/cf-services-contrib-2.yml

mkdir -p ~/bosh-workspace/deployments/cf
cd ~/bosh-workspace/deployments/cf
curl -O https://gist.github.com/joshuamckenty/8593730/raw/cf.yml.template
curl -O https://gist.github.com/joshuamckenty/8592327/raw/replace.sh
chmod a+x replace.sh
./replace.sh cf.yml.template cf.yml ~/credentials.sh
bosh deployment cf.yml


