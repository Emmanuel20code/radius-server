#!/bin/bash

# Ensure required environment variables are set
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set."
    exit 1
fi

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
tailscale up --authkey="$TAILSCALE_AUTH_KEY"

echo "Tailscale connected. Starting FreeRADIUS..."
/usr/sbin/radiusd -f -X
