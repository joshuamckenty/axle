# vim: tabstop=4 shiftwidth=4 softtabstop=4

# This is a templated file generated from files/farmboy/fabfile.py,
# by commands such as `farmboy vagrant.init` will produce an output
# version in your local directory that you can then modify to your
# heart's content.

import os

from farmboy import aptcacher
from farmboy import aws
from farmboy import core
from farmboy import django
from farmboy import dns
from farmboy import gitlab
from farmboy import gunicorn
from farmboy import haproxy
from farmboy import jenkins
from farmboy import nginx
from farmboy import socks5
from farmboy import tomcat
from farmboy import util
from farmboy import vagrant


from fabric.api import env
from fabric.api import execute
from fabric.api import task



# The Openstack utilities can launch your VMs for you using
# `farmboy openstack.build`. This setting tells them how many and which roles
# to use, it will cache their addresses by default into the farmboy.os.yaml
# file so that we can target them for the rest of our actions.
# POWER TIP: Use `farmboy openstack.refresh` to update the farmboy.os.yaml
#            file if you've manually changed your instances.
env.farmboy_os_instances = ['proxy', 'apt', 'web', 'web']

# We generally want to use a stock Ubuntu 13.04 cloud image, you'll need
# to figure out the ID of one (or upload it using the dashboard).
# POWER TIP: Or you can use our handy picker!
env.farmboy_os_image_id = util.load('farmboy_os_image_id', 'farmboy.os.yaml')

# These are the various OpenStack-related configuration options and their
# default values. They should be pretty self explanatory for people who've
# used OpenStack.

# env.farmboy_os_username = os.environ.get('OS_USERNAME', '')
# env.farmboy_os_password = os.environ.get('OS_PASSWORD', '')
# env.farmboy_os_tenant_name = os.environ.get('OS_TENANT_NAME', '')
# env.farmboy_os_auth_url = os.environ.get('OS_AUTH_URL', '')

# env.farmboy_os_image_user = 'ubuntu'
# env.farmboy_os_flavor_id = '2' #m1.small, usually
# env.farmboy_os_reservation_id = 'farmboy'
# env.farmboy_os_security_group = 'farmboy'
# env.farmboy_os_keypair = 'farmboy'
# env.farmboy_os_keyfile = 'farmboy.key'
# env.farmboy_os_keyfile_public = 'farmboy.pub'


# We're using `python-novaclient` for the built-in OpenStack tools, so if you
# use those you should define the common OpenStack environment variables in
# your shell:
#
#   OS_USERNAME
#   OS_PASSWORD
#   OS_TENANT_NAME
#   OS_AUTH_URL



# Private key that we'll use to connect to the machines
env.key_filename = 'farmboy.pem'

# Define which servers go with which roles.
# POWER TIP: These can defined as callables as well if you want to load
#            the servers in some more dynamic way.
# POWER TIP: You might also want to separate these out into a yaml file
#            and do `env.roledefs = yaml.load(open('farmboy.yaml'))`
#            or use the helper `env.roledefs = util.load_roledefs()`
env.roledefs.update(util.load_roledefs('farmboy.os.yaml'))

# Since we're be using apt caching, point out where that proxy will live.
# POWER TIP: If you're already using such a proxy, you can just point this
#            at that server and skip the `execute(aptcacher.deploy)` step.
if env.roledefs['apt']:
    apt = env.roledefs['apt'][0]
    env.farmboy_apt_proxy = 'http://%s:3142' % util.host(apt)

# Where our django app lives (this directory will be pushed to web servers).
# This is expected to be the directory that contains the manage.py file for
# a default django setup.
# POWER TIP: We expect this to be in the current directory by default
#            but a full path works here, too.
# POWER TIP: You can set the path directly as we do below in the execute
#            call, but if none is set it will default to using the this
#            env variable.
env.farmboy_django_app = 'demo'

# Where to find the template files to use when configuring services.
# POWER TIP: We'll fall back to the defaults shipped with farmboy for
#            any files not found in this location.
# POWER TIP: TODO(termie) Use `farmboy files $some_module` to get the
#            list and locations of files used for a given module.
env.farmboy_files = './files'


@task(default=True)
def demo():
    """Example deployment of an haproxy+nginx+gunicorn+django."""
    if env.roledefs['apt']:
        execute(aptcacher.deploy)
        execute(aptcacher.set_proxy)
    execute(core.install_user)
    execute(dns.hosts)
    execute(haproxy.deploy)
    execute(nginx.deploy)
    execute(gunicorn.deploy)
    execute(django.deploy, path=env.farmboy_django_app)

    print ('Alright! Check out your site at: http://%s'
            % util.host(env.roledefs['proxy'][0]))
