#!/bin/bash

# Ensure required environment variable is set
if [ -z "tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set."
    exit 1
fi

echo "Starting Tailscale..."
# --tun=userspace-networking is required for Railway containers
tailscaled --tun=userspace-networking &

echo "Waiting for tailscaled to start..."
sleep 5

echo "Authenticating Tailscale..."
tailscale up --authkey="tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa"

echo "Tailscale connected. Starting FreeRADIUS..."
/usr/sbin/radiusd -f -X
