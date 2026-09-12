#!/bin/bash

# Ensure required environment variable is set
if [ -z "tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set."
    exit 1
fi

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &

echo "Waiting for tailscaled to start..."
sleep 5

echo "Authenticating Tailscale..."
tailscale up --authkey="tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa"

echo "Tailscale connected. Starting FreeRADIUS..."

# Try to find the executable
RADIUS_PATH=$(which radiusd || which freeradius || echo "/usr/sbin/radiusd")

echo "Attempting to start FreeRADIUS at: $RADIUS_PATH"

if [ -f "$RADIUS_PATH" ]; then
    $RADIUS_PATH -f -X
else
    echo "ERROR: radius executable not found at $RADIUS_PATH. Listing contents of /usr/sbin/:"
    ls -l /usr/sbin/
    exit 1
fi
