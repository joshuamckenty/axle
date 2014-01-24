
BUILD ARTIFACTS TO INCLUDE IN AXLE PACKAGE: 
===========================================
 - (RELEASE 147)
 - Custom Stemcell
   - VMS Agent
   - Ganglia as bosh job
- Bosh CPI for VMS OpenStack


TROUBLESHOOTING:
================

NEUTRON STATIC IPS:
Make sure your "bosh" user has admin rights in the "cloudfoundry" project - this will allow it to create ports.


If you see "\"Error. Unable to associate floating ip\"" then likely your VM has been launched with two vNICs. 
Fix by specifying a net_id in cloud_properties in the appropriate yml file.

# See http://docs.openstack.org/network-admin/admin/content/advanceed_vm_creation.html

If you see lib/bosh/deployer/instance_manager/openstack.rb:124:in `discover_bosh_ip': undefined method `floating_ip_address' for nil:NilClass (NoMethodError)
Then you've got extra instances running, and you need to delete your existing bosh-deployments.yml file.

If you see "Error 80010: Job `common1' has specs with conflicting property definition styles between its job spec templates.  This may occur if colocating jobs, one of which has a spec file including `properties' and one which doesn't."

Then you need to use a newer version of your release yml template (with a different set of jobs on each host.)

If you time out while waiting for VMs to start or stop, set a state_timeout in microbosh.yml and redeploy it.

