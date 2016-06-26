#!/bin/bash


pair_a="vethA"
pair_b="vethB"
ipex="ipex"
gateway="10.0.0.1"
bridge_ip="10.0.0.2"
container_ipnet="10.0.0.3/24"

ifconfig $ipex || exit 1

ifconfig ipex 0.0.0.0
brctl addbr ${ipex}br
brctl addif ${ipex}br $ipex
ifconfig $ipex up

ifconfig ${ipex}br $bridge_ip netmask 255.255.255.0

mkdir -p tmp
echo $apsis_sandboxed_pid > tmp/pid

mkdir -p /var/run/netns
ln -s /proc/$apsis_sandboxed_pid/ns/net /var/run/netns/$apsis_sandboxed_pid

ip link add $pair_a type veth peer name $pair_b
#brctl addbr ${ipex}br
brctl addif ${ipex}br $pair_a
ip link set $pair_a up

ip link set $pair_b netns $apsis_sandboxed_pid
ip netns exec $apsis_sandboxed_pid ip link set dev $pair_b name eth0
ip netns exec $apsis_sandboxed_pid ip link set eth0 address 12:34:56:78:9a:bc
ip netns exec $apsis_sandboxed_pid ip link set eth0 up
ip netns exec $apsis_sandboxed_pid ip addr add $container_ipnet dev eth0
ip netns exec $apsis_sandboxed_pid ip route add default via $gateway