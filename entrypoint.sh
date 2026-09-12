#!/bin/bash

# Ensure required environment variable is set
if [ -z "tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set."
    exit 1
fi

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
TAILSCALE_PID=$!

echo "Waiting for tailscaled to start..."
sleep 5

echo "Authenticating Tailscale..."
tailscale up --authkey="tskey-auth-kn387nZ38911CNTRL-wqa8JBCPX57oThAJaaT157XqLZatuYDDa"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to authenticate Tailscale"
    kill $TAILSCALE_PID 2>/dev/null
    exit 1
fi

echo "Tailscale connected. Starting FreeRADIUS..."

# Try to find the executable
RADIUS_PATH=$(which radiusd || which freeradius || echo "/usr/sbin/radiusd")

echo "Attempting to start FreeRADIUS at: $RADIUS_PATH"

# Determine debug mode based on environment variable
DEBUG_FLAGS=""
if [ "$DEBUG_MODE" = "true" ] || [ "$DEBUG_MODE" = "1" ]; then
    echo "DEBUG_MODE enabled: Running with extensive logging (-X)"
    DEBUG_FLAGS="-X"
else
    echo "Production mode: Running with standard logging (set DEBUG_MODE=true to enable extensive debug)"
fi

if [ -f "$RADIUS_PATH" ]; then
    $RADIUS_PATH -f $DEBUG_FLAGS
else
    echo "ERROR: radius executable not found at $RADIUS_PATH. Listing contents of /usr/sbin/:"
    ls -l /usr/sbin/
    exit 1
fi
