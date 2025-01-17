#!/bin/bash

echo "Enabling IP forwarding in the container..."
sysctl -w net.ipv4.ip_forward=1

if [[ "$(sysctl net.ipv4.ip_forward)" == "net.ipv4.ip_forward = 1" ]]; then
  echo "IP forwarding is enabled."
else
  echo "Failed to enable IP forwarding."
  exit 1
fi

echo "Configuring NAT rules in the container..."
iptables -t nat -F  # Flush NAT table only

# Configure NAT rules for traffic from 10.9.8.0/24
iptables -t nat -A POSTROUTING -s 10.9.8.0/24 ! -o eth0 -j MASQUERADE

# Allow forwarding for 10.9.8.0/24
iptables -A FORWARD -s 10.9.8.0/24 -j ACCEPT
iptables -A FORWARD -d 10.9.8.0/24 -j ACCEPT

# Verify iptables rules
echo "Current iptables NAT rules:"
iptables -t nat -L -n -v

echo "Current iptables FORWARD rules:"
iptables -L FORWARD -n -v

echo "NAT Router setup complete. Container is now running."
sleep infinity
