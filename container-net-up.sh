#!/bin/bash

pair_a="vethA"
pair_b="vethB"

# random mac address
hexchars="0123456789abcdef"
mac=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )


#mkdir -p tmp
#echo $apsis_sandboxed_pid > tmp/pid
echo $apsis_sandboxed_pid

mkdir -p /var/run/netns
ln -s /proc/$apsis_sandboxed_pid/ns/net /var/run/netns/$apsis_sandboxed_pid

ip link add $pair_a type veth peer name $pair_b
ip link set $pair_a master ${ipexbr}
ip link set $pair_a up

ip link set $pair_b netns $apsis_sandboxed_pid
ip netns exec $apsis_sandboxed_pid ip link set dev $pair_b name eth0
ip netns exec $apsis_sandboxed_pid ip link set eth0 address 06${mac}
ip netns exec $apsis_sandboxed_pid ip link set eth0 up
ip netns exec $apsis_sandboxed_pid ip addr add $container_ipnet/$subnet dev eth0
ip netns exec $apsis_sandboxed_pid ip route add default via $gateway
