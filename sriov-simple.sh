#!/bin/bash
set -x

echo "Sourcing openrc"
source /root/openstack-configs/openrc

echo "Clean up the networks and instances"
~/clean.sh

echo "Creating  a network"
neutron net-create private

echo "Creating a subnet"
neutron subnet-create private 192.168.55.0/24

net=$(neutron net-show -f value -c id private)
echo "Booting vm with sriov port"

userdata=`mktemp`

cat >$userdata <<'EOF'
#!/bin/sh

for f in  /sys/bus/pci/devices/* ; do echo `basename $f`: `cat $f/vendor`:`cat $f/device`; done
ls -l /sys/class/net
modprobe i40e
ifconfig -a
lsmod
EOF

port_id=`neutron port-create -f value -c id $net --name sriov-port --binding:vnic_type direct | tail -1`
nova boot --config-drive true --user-data $userdata --flavor m1.medium --image RHEL-guest-image --nic port-id=$port_id vm1

sleep 2

echo "Check the vm state"
nova list

echo "Done"
