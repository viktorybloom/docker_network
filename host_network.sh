#!/bin/bash

echo "Enabling IP forwarding on the host..."
sysctl -w net.ipv4.ip_forward=1

if ! grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf
  sysctl -p
fi

echo "Adding static route for 10.9.8.0/24 (if necessary)..."
if ! ip route | grep -q "10.9.8.0/24"; then
  ip route add 10.9.8.0/24 via 192.168.1.100 dev eth0
  echo "Static route added."
else
  echo "Static route already exists."
fi

echo "Configuring iptables rules for forwarding..."
iptables -I DOCKER-USER 1 -s 10.9.8.0/24 -d 192.168.1.0/24 -j ACCEPT
iptables -I DOCKER-USER 2 -s 192.168.1.0/24 -d 10.9.8.0/24 -j ACCEPT

echo "Host network setup complete."
