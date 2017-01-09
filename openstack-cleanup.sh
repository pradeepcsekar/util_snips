#!/bin/bash

echo "Sourcing Openrc"
echo "==============="
source /root/openstack-configs/openrc

echo "Existing nova VMs: " 
echo "=================="
nova list
echo ""
echo "Deleting nova VMs "
echo "=================="
for i in $(nova list | awk  '{print $2}' | grep -vi id ); do  nova delete  $i; done

echo "Existing neutron pors: " 
echo "======================"
neutron port-list
echo ""
echo "Deleting neutron ports"
echo "======================"
for i in $(neutron port-list | awk  '{print $2}' | grep -v id ); do neutron port-delete $i; done

echo "Clearing router gateways"
echo "========================"
neutron router-list
for i in $(neutron router-list | awk  '{print $2}' | grep -v id ); do neutron router-gateway-clear $i; done

echo "Existing neutron routers: " 
echo "========================"
neutron router-list
echo ""
echo "Deleting neutron routers"
echo "========================"
for i in $(neutron router-list | awk  '{print $2}' | grep -v id ); do neutron router-delete $i; done

echo "Exiting neutron networks: "
echo "========================"
neutron net-list
echo ""
echo "Deleting neutron networks"
echo "========================="
for i in $(neutron net-list | awk  '{print $2}' | grep -v id ); do neutron net-delete $i; done

echo "Done!"
echo "====="
