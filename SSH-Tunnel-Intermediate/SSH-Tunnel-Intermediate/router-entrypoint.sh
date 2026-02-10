#!/bin/bash
set -e

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Clear any existing iptables rules (safe in this isolated lab)
iptables -F
iptables -t nat -F
iptables -X

# Allow forwarding between interfaces
iptables -P FORWARD ACCEPT

# 1. DROP traffic from attacker (172.28.0.10) → user-2/5
iptables -A FORWARD -s 172.28.0.10 -d 172.29.0.11 -j DROP
iptables -A FORWARD -s 172.28.0.10 -d 172.30.0.30 -j DROP
iptables -A FORWARD -s 172.28.0.10 -d 172.31.0.40 -j DROP
iptables -A FORWARD -s 172.28.0.10 -d 172.32.0.50 -j DROP

# 2. DROP traffic from user-1 (172.28.0.11) to user 3/5
iptables -A FORWARD -s 172.28.0.11 -d 172.30.0.30 -j DROP
iptables -A FORWARD -s 172.28.0.11 -d 172.31.0.40 -j DROP
iptables -A FORWARD -s 172.28.0.11 -d 172.32.0.50 -j DROP

# 3. DROP traffic from user-2 (172.29.0.11) to user-4-5
iptables -A FORWARD -s 172.29.0.11 -d 172.31.0.40 -j DROP
iptables -A FORWARD -s 172.29.0.11 -d 172.32.0.50 -j DROP

# 4. DROP traffic from user-3 (172.30.0.30) to user-5
iptables -A FORWARD -s 172.30.0.30 -d 172.32.0.50 -j DROP


# ALLOW traffic from student box (172.28.0.11) → user-1 (172.29.0.11)
iptables -A FORWARD -s 172.28.0.11 -d 172.29.0.11 -j ACCEPT

# Allow all other forwarding
iptables -A FORWARD -j ACCEPT

# (Optional) masquerade outbound when needed — here we don't NAT internal subnets to host
# but uncomment if you want NAT from net_a->net_b or vice versa:
# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Show interface and route information (for debug)
echo "=== IFCONFIG ==="
ip -br addr
echo "=== ROUTES ==="
ip route

# Keep container alive for debugging
tail -f /dev/null
