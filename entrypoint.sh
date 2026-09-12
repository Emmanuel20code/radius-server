#!/bin/bash

# Ensure required environment variable is set
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set."
    exit 1
fi

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
TAILSCALE_PID=$!

echo "Waiting for tailscaled to start..."
sleep 5

echo "Authenticating Tailscale..."
tailscale up --authkey="$TAILSCALE_AUTH_KEY"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to authenticate Tailscale"
    kill $TAILSCALE_PID 2>/dev/null
    exit 1
fi

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
