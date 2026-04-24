#!/bin/bash
# Load Testing Script - GadgetZone

WEB_SERVER_IP="YOUR_WEB_SERVER_IP_HERE"
CONCURRENT_USERS=500
TOTAL_REQUESTS=10000

echo "=== Load Test ==="
echo "Target: https://$WEB_SERVER_IP"
echo "Concurrent Users: $CONCURRENT_USERS"
echo "Total Requests: $TOTAL_REQUESTS"

if ! command -v ab &> /dev/null; then
    sudo apt update
    sudo apt install apache2-utils -y
fi

ab -k -c $CONCURRENT_USERS -n $TOTAL_REQUESTS "https://$WEB_SERVER_IP/" | tee results.txt

echo ""
echo "=== Results ==="
grep "Time per request:" results.txt | head -1
grep "Failed requests:" results.txt