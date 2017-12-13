#!/bin/bash

## ADAPT THESE TO YOUR CONFIGURATION
iface=xenbr0
guest_user=aherrera
##

# Arguments:
# $1 = domain-id
id=$1

# Gets the MAC address in caps.
mac=$(xenstore-read /local/domain/$id/device/vif/0/mac)
umac=$(echo $mac | tr "[:lower:]" "[:upper:]")

# Gets the IP from MAC through Nmap.
net=$(ip address show $iface | grep "inet " | awk '{print $2}' \
| sed 's/\.[0-9]*\//\.0\//')
ip=$(nmap -sP $net | grep -B 2 $umac | grep Nmap | awk '{print $5}')

# Establishes SSH connection.
ssh $guest_user@$ip
