FROM debian:bookworm-slim

# Install Tailscale and FreeRADIUS
RUN apt-get update && apt-get install -y \
    freeradius \
    freeradius-utils \
    curl \
    && curl -fsSL https://tailscale.com/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and entrypoint
COPY radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose RadSec port (though you'll use Tailscale IP)
EXPOSE 2083

ENTRYPOINT ["/entrypoint.sh"]
