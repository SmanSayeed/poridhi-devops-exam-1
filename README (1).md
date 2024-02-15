
# Saadman Sayeed - Poridhi DevOps Course - Exam-1

## Project 1: Creating two namespaces and communicating via veth

### 1# Creating two namespaces

``` ubuntu command
sudo ip netns add 'ns1'
sudo ip netns add 'ns2'
```

### 2# Creating Veth

``` ubuntu command
sudo ip link add 'eth1' type veth peer name 'eth2'
```

### 2# Connect namespaces with Veth

``` ubuntu command
sudo ip link set 'eth1' nets 'ns1'
sudo ip link set 'eth2' nets 'ns2'
```

### 3# Connect namespaces with Veth

``` ubuntu command
sudo ip link set 'eth1' netns 'ns1'
sudo ip link set 'eth2' netns 'ns2'
```

### 4# Creating interface inside namespaces

``` ubuntu command
sudo ip netns exec 'ns1' ip link set 'eth1' name 'eth0'
sudo ip netns exec 'ns2' ip link set 'eth2' name 'eth0'
```

### 5# Assign IP to namespaces

``` ubuntu command
sudo ip netns exec 'ns1' ip addr add 192.168.1.1/24
sudo ip netns exec 'ns2' ip addr add 192.168.2.1/24
```

### 5# Bring up the interfaces

``` ubuntu command
sudo ip netns exec 'ns1' ip link set 'lo' up
sudo ip netns exec 'ns1' ip link set 'eth0' up
sudo ip netns exec 'ns2' ip link set 'lo' up
sudo ip netns exec 'ns2' ip link set 'eth0' up
```

### 6# Bring up the interfaces

``` ubuntu command
sudo ip netns exec 'ns1' ip link set 'lo' up
sudo ip netns exec 'ns1' ip link set 'eth0' up
sudo ip netns exec 'ns2' ip link set 'lo' up
sudo ip netns exec 'ns2' ip link set 'eth0' up
```

### 7# Set default port address:
``` ubuntu command
sudo ip netns exec 'ns1' ip route add default via 192.168.1.1 dev eth0

```
### 8# Connection testing:
``` ubuntu command
sudo ip netns exec 'ns1' ping -c 1 192.168.2.1
sudo ip netns exec 'ns2' ping -c 1 192.168.1.1
```

## Project 2: Creating two namespaces and communicating via Bridge


### 1# Creating namespaces :
--------------------------

``` ubuntu command
#create two network nampespace
sudo ip netns add ns1
sudo ip netns add ns2

#By default they are down, need to up
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip link

sudo ip netns exec ns2 ip link set lo up
sudo ip netns exec ns2 ip link
```

### 2# Creating Bridge:
------------------------
``` ubuntu command
#create bridge
sudo ip link add br0 type bridge
# up the created bridge and check whether it is created and in UP/UNKNOWN state
sudo ip link set br0 up
sudo ip link
```

### 3# Configure IP to bridge:
``` ubuntu command
sudo ip addr add 192.168.1.1/24 dev br0
# check whether the ip is configured and also ping to ensure
sudo ip addr
ping -c 2 192.168.1.1
```

### 4# Create two Veth for two network netns and attach to bridge:
``` ubuntu command
# For ns1

# creating a veth pair which have two ends identical veth0 and ceth0
sudo ip link add veth0 type veth peer name ceth0
# connect veth0 end to the bridge br0
sudo ip link set veth0 master br0
# up the veth0 
sudo ip link set veth0 up 
# connect ceth0 end to the netns ns1
sudo ip link set ceth0 netns ns1
# up the ceth0 using 'exec' to run command inside netns
sudo ip netns exec ns1 ip link set ceth0 up
# check the link status 
sudo ip link


# For ns2; do the same as ns1

sudo ip link add veth1 type veth peer name ceth1
sudo ip link set veth1 master br0
sudo ip link set veth1 up
sudo ip link set ceth1 netns ns2
sudo ip netns exec ns2 ip link set ceth1 up

```

### 5# Add IP address:
``` ubuntu command
# For ns1
sudo ip netns exec ns1 ip addr add 192.168.1.10/24 dev ceth0
sudo ip netns exec ns1 ping -c 2 192.168.1.10
sudo ip netns exec ns1 ip route

# For ns2
sudo ip netns exec ns2 ip addr add 192.168.1.11/24 dev ceth1
sudo ip netns exec ns2 ping -c 2 192.168.1.11
sudo ip netns exec ns2 ip route 

```

### 5# Add default route to ensure connectivity:
``` ubuntu command
sudo ip netns exec ns1 ip route add default via 192.168.1.1
sudo ip netns exec ns1 route -n
# Do the same for ns2
sudo ip netns exec ns2 ip route add default via 192.168.1.1
sudo ip netns exec ns2 route -n
# now first ping the host machine eth0
ip addr | grep eth0
# ping from ns1 to host ip
sudo ip netns exec ns1 ping 172.31.13.55
```
### 6# Enable ip forwaring:
``` ubuntu command
sudo sysctl -w net.ipv4.ip_forward=1
sudo cat /proc/sys/net/ipv4/ip_forward

```
### 7# Use of NAT (network address translation) by placing an iptables rule in the POSTROUTING chain of the nat table:
``` ubuntu command
sudo iptables \
        -t nat \
        -A POSTROUTING \
        -s 192.168.1.0/24 ! -o br0 \
        -j MASQUERADE

```

### 8# open a service in one of the namespaces and try to get response from outside:
``` ubuntu command
sudo nsenter --net=/var/run/netns/netns1
python3 -m http.server --bind 192.168.1.10 3000

```

### 9# Connection testing:
``` ubuntu command
telnet 65.2.35.192 5000
```





