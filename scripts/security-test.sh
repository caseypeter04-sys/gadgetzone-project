#!/bin/bash
# Security Testing Script - GadgetZone

WEB_SERVER_IP="YOUR_WEB_SERVER_IP_HERE"

echo "=== Security Test ==="

if ! command -v nmap &> /dev/null; then
    sudo apt update
    sudo apt install nmap -y
fi

echo "[1/2] Port scan..."
nmap -p- $WEB_SERVER_IP

echo ""
echo "[2/2] HTTPS check..."
curl -k -I https://$WEB_SERVER_IP/ | head -3