

#!/bin/bash
# Saadman Sayeed - Poridhi DevOps Course - Exam-1

## Project 1: Creating two namespaces and communicating via veth

### 1# Creating two namespaces


sudo ip netns add 'ns1'
sudo ip netns add 'ns2'

### 2# Creating Veth


sudo ip link add 'eth1' type veth peer name 'eth2'


### 2# Connect namespaces with Veth


sudo ip link set 'eth1' nets 'ns1'
sudo ip link set 'eth2' nets 'ns2'


### 3# Connect namespaces with Veth


sudo ip link set 'eth1' netns 'ns1'
sudo ip link set 'eth2' netns 'ns2'


### 4# Creating interface inside namespaces


sudo ip netns exec 'ns1' ip link set 'eth1' name 'eth0'
sudo ip netns exec 'ns2' ip link set 'eth2' name 'eth0'


### 5# Assign IP to namespaces

sudo ip netns exec 'ns1' ip addr add 192.168.1.1/24
sudo ip netns exec 'ns2' ip addr add 192.168.2.1/24


### 5# Bring up the interfaces


sudo ip netns exec 'ns1' ip link set 'lo' up
sudo ip netns exec 'ns1' ip link set 'eth0' up
sudo ip netns exec 'ns2' ip link set 'lo' up
sudo ip netns exec 'ns2' ip link set 'eth0' up


### 6# Bring up the interfaces

sudo ip netns exec 'ns1' ip link set 'lo' up
sudo ip netns exec 'ns1' ip link set 'eth0' up
sudo ip netns exec 'ns2' ip link set 'lo' up
sudo ip netns exec 'ns2' ip link set 'eth0' up


### 7# Set default port address:

sudo ip netns exec 'ns1' ip route add default via 192.168.1.1 dev eth0

### 8# Connection testing:

sudo ip netns exec 'ns1' ping -c 1 192.168.2.1
sudo ip netns exec 'ns2' ping -c 1 192.168.1.1
