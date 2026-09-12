#!/bin/bash

# Ensure required environment variable is set
if [ -z "$TAILSCALE_AUTH_KEY" ]; then
    echo "ERROR: TAILSCALE_AUTH_KEY must be set in Railway environment variables."
    exit 1
fi

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
TAILSCALE_PID=$!

echo "Waiting for tailscaled to start..."
sleep 5

echo "Authenticating Tailscale..."
# Use the variable from Railway, NOT a hardcoded key
tailscale up --authkey="$TAILSCALE_AUTH_KEY"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to authenticate Tailscale"
    kill $TAILSCALE_PID 2>/dev/null
    exit 1
fi

echo "Tailscale connected. Starting FreeRADIUS..."

# Try to find the executable
RADIUS_PATH=$(which radiusd || which freeradius || echo "/usr/sbin/freeradius")

echo "Attempting to start FreeRADIUS at: $RADIUS_PATH"

# Determine debug mode based on environment variable
DEBUG_FLAGS=""
if [ "$DEBUG_MODE" = "true" ] || [ "$DEBUG_MODE" = "1" ]; then
    echo "DEBUG_MODE enabled: Running with extensive logging (-X)"
    DEBUG_FLAGS="-X"
else
    echo "Production mode: Running with standard logging"
fi

if [ -f "$RADIUS_PATH" ]; then
    # -f keeps the process in the foreground so the container stays alive
    $RADIUS_PATH -f $DEBUG_FLAGS
else
    echo "ERROR: radius executable not found at $RADIUS_PATH. Listing contents of /usr/sbin/:"
    ls -l /usr/sbin/
    exit 1
fi
