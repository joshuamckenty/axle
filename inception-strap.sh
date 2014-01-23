#!/usr/bin/env bash

# source /usr/local/share/chruby/chruby.sh
# chruby ruby-2.0.0-p247
# ./bosh-bootstrap/bin/bosh-bootstrap deploy


sudo apt-get install -y git-core 
curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
