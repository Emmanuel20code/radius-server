FROM debian:bookworm-slim

# Install dependencies, FreeRADIUS, and Tailscale
RUN apt-get update && apt-get install -y \
    freeradius \
    freeradius-utils \
    curl \
    ca-certificates \
    && curl -fsSL https://tailscale.com/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and entrypoint
COPY radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose standard RADIUS ports (UDP)
EXPOSE 1812/udp 1813/udp

# Optional: Expose TCP ports for RadSec if using TLS
# EXPOSE 2083/tcp 2084/tcp

ENTRYPOINT ["/entrypoint.sh"]
